class ERP::Customer < ActiveRecord::Base
  include ERPSupport
  
  # Validations
  # validates_format_of :phone, :with => /^[\d\(\)\+\-\,\ ]+$/, :message => "contains invalid character.",
  #   :if => Proc.new { |customer| customer.phone.blank? == false }
  
  has_many :sales_orders, :foreign_key => "erp_customer_id"
  has_many :contact_people, :foreign_key => "erp_customer_id"
  has_many :addresses, :foreign_key => "parent_id", :class_name => "ERP::CustomerAddress" 
  with_options(:class_name => 'ERP::SalesOrder', :foreign_key => 'erp_customer_id') do |c|
    c.has_many :open_orders, :conditions => 'deleted = false AND completed = false'
    c.has_many :close_orders, :conditions => 'deleted = false AND completed = true'
  end
  
  # Create a new contact person under this customer account.
  # Return a instance of ERP::ContactPerson contains attributes
  #   and error messages if it is invalid.
  def append_contact_person!(params)
    contact_person = ERP::ContactPerson.new params
    return contact_person unless contact_person.valid?
    
    self.class.transaction(self) do
      contact_person = self.contact_people.create! params
      contact_person.bind_store_user!
      return contact_person
    end
  end
  
  def modified_orders
    self.open_orders.find_all_by_synchronized false
  end
  
  # Find out customer's bombsquad email. Validation error will be added if
  # bombsquad does not exist.
  def rep_email
    return if self.assigned_to.nil?
    
    if (bomb_squad = AppConfig.CUSTOMER_STAFF[self.assigned_to])
      return "\"#{name}\" <#{bomb_squad_email}>"
    else
      raise "BombSquad \"#{self.assigned_to}\" is not existing for \"#{self.account_num}\""
    end
  end
  
  # Summary for this customer account
  # def summary
  #   @summary ||= Summary.new( self )
  # end
  
  attr_reader :original_email
  def email=( email )
    @original_email ||= self.email
    super( email )
  end
  
  # After updating customer's email address (primary contact / profile), a notification mail will
  #   be sent to the original email address.
  def after_update
    if @original_email && @original_email != self.email
      MyAccountMailer.deliver_update_email_address( self )
      @original_email = nil
    end
  end
  
  # Commit local modification to AX server
  def update_ax( options={} )
    options = { :customer => self, :contacts => [], :addresses => [] }.merge( options )
    response = ERP::ERPAgent.enqueue(
      :url => AppConfig.SOAP_CU_UPDATE_SERV,
      :body => self.class.generate_xml( "update_customer", options )
    )
    
    if response
      # return synchronize
    else
      return false
    end
  end
  
  def synchronize( force_sync_orders=false )
    output_log "#{self.account_num} SYNC CUSTOMER ACCOUNT"
    response = ERP::ERPAgent.post(
      :url => AppConfig.SOAP_CU_SERV,
      :body => self.class.generate_xml( "read_customer", :customer => self )
    )
    
    if response
      begin
        self.class.transaction do
          fetch_data( response.body, force_sync_orders )
          after_synchronize # callback
          update_attribute( :synchronized, true )
        end
        return true
      rescue => exception
        # Handle the records with validation failed.
        ERP::ERPMailer.deliver_invalid_record( self, exception )
        output_log "#{self.account_num} #{exception.message}"
      end
    end
    
    return false
  end
  
  # Undo all changes of customer by re-synchronizing data
  def undo_changes
    return synchronize( true )
  end
  
  # Rebuild accessibilities to this account according to given emails or existing contacts.
  # Only store users whose email is in this collection are accessible to account,
  #   and remove others by clear their erp account number.
  # Referer to "My Account / Sign in"
  def rebuild_accessibilities( emails=nil )
    emails ||= self.contact_people.collect{ |contact| contact.email }
    emails << self.email
    StoreUser.transaction do
      StoreUser.update_all( "erp_account_number = NULL", ["erp_account_number = ?", self.account_num] )
      StoreUser.update_all(
        "erp_account_number = '#{self.account_num}'",
        ['email_address in (?)', emails]
      ) unless emails.empty?
    end
  end
  
  # private
  
  # Fetch data from returning xml
  def fetch_data( xml, force_sync_orders )
    doc = Hpricot.XML( xml )
    
    output_log "Update Customer Attributes..."
    # Basic Attributes
    self.attributes = {
      :account_balance      => (doc/"CustTable_1/AccountBalance").inner_text,
      :discounts            => (doc/"CustTable_1/Discounts").inner_text,
      :currency             => (doc/"CustTable_1/Currency").inner_text,
      :first_name           => (doc/"CustTable_1/CustFirstName").inner_text,
      :last_name            => (doc/"CustTable_1/CustLastName").inner_text,
      :email                => (doc/"CustTable_1/Email").inner_text,
      :language_id          => (doc/"CustTable_1/LanguageId").inner_text,
      :phone                => (doc/"CustTable_1/Phone").inner_text,
      :red_one_shipped      => ((doc/"CustTable_1/RedOneShipped").inner_text.upcase == 'TRUE'),
      :created_date         => (doc/"CustTable_1/CreatedDate").inner_text,
      :erp_modstamp         => ax_modstamp(doc/"CustTable_1")
    }
    
    # HOT FIX
    # Kick has not implemented codes for phone validation. Before that, skip this validation
    #   in synchronization process.
    # self.save!
    self.save_with_validation( false )
    
    # Addresses
    address_nodes = doc/'CustTable_1/Address_1'
    address_nodes.each do |node|
      address = (
        addresses.find_by_record_id( (node/'RecId').inner_text ) ||
        addresses.find_by_street_and_city( (node/'Street').inner_text, (node/'City').inner_text ) ||
        addresses.build
      )
      address.attributes = {
        :address           => (node/'Address').inner_text,
        :city              => (node/'City').inner_text,
        :country_region_id => (node/'CountryRegionId').inner_text,
        :state             => (node/'State').inner_text,
        :street            => (node/'Street').inner_text,
        :record_id         => (node/'RecId').inner_text,
        :address_type      => (node/'Type').inner_text,
        :zip_code          => (node/'ZipCode').inner_text
      }
      address.save!
    end
    
    # Contacts
    contact_nodes = doc/'CustTable_1/ContactPerson_1'
    
    # Delete contact people in local database if this contact has no longer been exists in AX
    ax_contact_emails = contact_nodes.collect { |node| (node/'Email').inner_text }
    ax_contact_emails << self.email unless ax_contact_emails.include?( self.email )
    # self.contact_people.each do |contact|
    #   contact.destroy if !contact.newly_created? && !ax_contact_emails.include?( contact.email )
    # end
    self.contact_people.clear

    # Update Contacts
    contact_nodes.each do |node|
      contact = self.contact_people.build
      contact.attributes = {
        :first_name => (node/'FirstName').inner_text,
        :last_name => (node/'LastName').inner_text,
        :email => (node/'Email').inner_text.strip,  # StoreUser.validate_email_address
        :name => (node/'Name').inner_text,
        :newly_created => false
      }
      contact.save!
    end
    
    # Rebuild accessibilities to this account
    output_log "Rebuilding accessibilities for account '#{self.account_num}' ..."
    self.rebuild_accessibilities( ax_contact_emails )
    
    # Additional, also remove accessibility from deprecated web accounts, those were not created
    #   by My Account or AX (historical data)
    StoreUser.update_all "erp_account_number = null", ['erp_account_number = ? and email_address not in (?)', self.account_num, ax_contact_emails]
    
    # Sales Orders
    sales_nodes = (doc/'CustTable_1'/'SalesTable_1'/'SalesId')
    
    # Delete sales orders from local database if they are no longer exists in
    # ERP service.
    deleted_orders = sales_orders.map(&:sales_id) - sales_nodes.map(&:inner_text)
    unless deleted_orders.blank?
      ERP::SalesOrder.update_all('deleted = true', ['sales_id IN (?)', deleted_orders])
    end
    
    sales_nodes.each do |node|
      sales_id = node.inner_text
      output_log "Found Sales Order #{ sales_id }"
      sales_order = sales_orders.find_by_sales_id( sales_id ) || sales_orders.build( :sales_id => sales_id )
      if force_sync_orders || sales_order.new_record? || sales_order.erp_modstamp.nil? || ax_modstamp(node) > sales_order.erp_modstamp
        output_log "#{sales_id} Begin Synchronize Sales Order\n"
        # if sales_order.new_record? && !sales_order.synchronize
        if !sales_order.synchronize
          sales_orders.delete_if { |order| order == sales_order }
        end
      else
        output_log "#{sales_id} Skipped"
      end
    end
  end
  
  
  private
  
  def after_synchronize
    ERP::SerialNumber.deliver_notifications_to( self.account_num )
  end
  
end
