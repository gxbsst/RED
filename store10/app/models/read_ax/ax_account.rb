class AxAccount < ActiveRecord::Base
  require 'erp/thread_pool'
  
  has_many :ax_orders, :conditions => ['status <> ?', 'ERROR']
  has_many :ax_account_addresses
  has_many :ax_account_contact_people
  
  has_one :ax_account_invoice_address,  :class_name => 'AxAccountAddress', :conditions => ['address_type = ?', 'Invoice']
  has_one :ax_account_delivery_address, :class_name => 'AxAccountAddress', :conditions => ['address_type = ?', 'Delivery']
  has_one :ax_account_master_contact_person, :class_name => 'AxAccountContactPerson', :order => 'id ASC'
  
  # Set initial records number
  INIT_RECORDS = 2500

  # Set max failed account number hold by counter container.
  MAX_COUNTER = 10
  
  # Class Method Begin Here.
  class << self
    def sync
      init_records
      
      # sync with AX up to date.
      append_records
      
      # update all records in single process.
      update_records

      # Update all records concurrency.
      #update_all
    end
    
    def init_records(range = nil)
      if AxAccount.count == 0
        range ||= INIT_RECORDS     # fill default number records.
        raise TypeError unless range.is_a?(Fixnum)
        records = []
        range.times {|i| records << "('#{next_ax_account_number(i)}')"}
        connection.execute "INSERT INTO #{table_name} (ax_account_number) VALUES#{records.join(",")}"
      end
    end
    
    # sync with AX up to date.
    def append_records
      # counter is a container hold numbers of AxAccount instance.
      counter = []
      begin
        if counter.empty?
          counter << new(:ax_account_number => next_ax_account_number)
        else
          counter << new(:ax_account_number => next_ax_account_number(counter.last.ax_account_number))
        end
        
        account, addresses = counter.last.fetch_data
        counter.last.attributes = account
        addresses.each do |attr|
          counter.last.ax_account_addresses << AxAccountAddress.new(attr)
        end
        counter.each {|o| o.save }
        append_records  # recursive invode mothod self
      rescue => ex
        puts ex.message if AppConfig.DEBUG_MODE
        retry unless counter.size == MAX_COUNTER
      end
    end
    
    # update all records in single process.
    def update_records
      find(:all).each do |record|
        record.update_record
      end
    end

    # Update all records concurrency.
    def update_all
      pool = ThreadPool.new(5)
      
      find(:all).each do |record|
        pool.process do
          begin
            rcd = record
            rcd.update_record
          rescue => ex
            # mark record status to "500 ERROR".
            # if successful update at previous, just skip it.
            rcd.update_attribute(:status, "ERROR")
          ensure
            # clear out old connections.
            ActiveRecord::Base.verify_active_connections!
          end
        end
      end
    end
    
    def next_ax_account_number(current_number = nil)
      case
      when  current_number.blank? && count == 0 then current_number = "CU 0100000"
      when  current_number.blank? && count != 0 then current_number = maximum(:ax_account_number)
      end
      
      if current_number.is_a?(Fixnum)
        current_number += 100000
      end
      
      "CU " << sprintf("%07d", current_number.to_s.gsub(/\D/, '').to_i.next)
    end
    
    def check_ax_account_number_sequence
      case
        # empty or only one record in table.
      when count <= 1 then return true
        # only two records in table.
      when count == 2  
        records = self.find(:all, :order => 'id ASC')
        return false unless records.first.ax_account_number == next_ax_account_number(0) # commit this line if first isn't restrict.
        return false unless records.last.ax_account_number == next_ax_account_number(records.first.ax_account_number)
      else # more than two records.
        numbers = AxAccount.find(:all).collect(&:ax_account_number)
        (1...count).each do |i|
          return false unless next_ax_account_number(numbers[i-1]) == numbers[i]
        end
      end
      
      return true
    end
    
    def request_xml(ax_account_number)
      # ax_account_number can't empty and legal format like "SO 0000001"
      unless !ax_account_number.blank? && ax_account_number.match(/^CU\s[0-9]{7}$/)
        raise RuntimeError, "Ax order number empty or illegal format!"
      end
      
      xml = ""
      doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      doc.instruct!
      doc.soap12:Envelope,
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
        "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
        doc.soap12 :Body do
          doc.readCustomers :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/Customers" do
            doc.DocumentContext do
              doc.MessageId( UUID.random_create.to_s )
              doc.SourceEndpointUser( AppConfig.SOAP_USER )
              doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
              doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
            end
            doc.EntityKey :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/EntityKey" do
              doc.KeyData do
                doc.KeyField do
                  doc.Field( "AccountNum" )
                  doc.Value( ax_account_number )
                end
              end
            end
          end
        end
      end
    end
 
    def httpagent(options = {})
      options = {
        :iis_user     => AppConfig.IIS_USER,
        :iis_pass     => AppConfig.IIS_PASS,
        :url          => AppConfig.SOAP_CU_SERV,
        :content_type => "application/soap+xml; charset=utf-8;",
        :body         => ""
      }.merge(options)
    
      # Print request body out to STDOUT
      ErpHelper.logger(options[:body]) if AppConfig.DEBUG_MODE
    
      uri = URI.parse(options[:url])
      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(options[:iis_user], options[:iis_pass])
      request.set_content_type(options[:content_type])
      request.body = options[:body]
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    
      response = http.request(request)
    
      # output response message.
      if AppConfig.DEBUG_MODE
        ErpHelper.logger("HTTP Response Code: #{response.code}", 'purple')
        ErpHelper.logger("HTTP Response Is a HTTPSuccess: #{response.is_a?(Net::HTTPSuccess).to_s}", 'purple')
        ErpHelper.logger(response.body, "purple")
      end

      raise unless response.is_a? Net::HTTPSuccess
      
      return response
    end
  end
  
  # Instance Method Begin Here.
  def fetch_data
    xml = AxAccount.httpagent(:body => AxAccount.request_xml(ax_account_number)).body
    doc = Hpricot.XML(xml)
    
    account = {
      :account_balance               => (doc/"CustTable_1/AccountBalance").inner_text,
      :discounts                     => (doc/"CustTable_1/Discounts").inner_text,
      :currency                      => (doc/"CustTable_1/Currency").inner_text,
      :cust_first_name               => (doc/"CustTable_1/CustFirstName").inner_text,
      :cust_last_name                => (doc/"CustTable_1/CustLastName").inner_text,
      :email                         => (doc/"CustTable_1/Email").inner_text,
      :cust_group                    => (doc/"CustTable_1/CustGroup").inner_text,
      :language_id                   => (doc/"CustTable_1/LanguageId").inner_text,
      :phone                         => (doc/"CustTable_1/Phone").inner_text,
      :red_one_shipped               => (doc/"CustTable_1/RedOneShipped").inner_text,
      :address                       => (doc/"CustTable_1/Address").inner_text,
      :city                          => (doc/"CustTable_1/City").inner_text,
      :country_region_id             => (doc/"CustTable_1/CountryRegionId").inner_text,
      :state                         => (doc/"CustTable_1/State").inner_text,
      :street                        => (doc/"CustTable_1/Street").inner_text,
      :tele_prod_tax_exempt          => (doc/"CustTable_1/TeleProdTaxExempt").inner_text,
      :zip_code                      => (doc/"CustTable_1/ZipCode").inner_text,
      :created_date                  => (doc/"CustTable_1/CreatedDate").inner_text,
      :modified_date                 => (doc/"CustTable_1/ModifiedDate").inner_text,
      :status                        => "UPDATE"
    }
    
    addresses = []
    (doc/:Address_1).each do |addr_doc|
      addresses << {
        :ax_account_number => ax_account_number,
        :address           => (addr_doc/:Address).inner_text,
        :city              => (addr_doc/:City).inner_text,
        :country_region_id => (addr_doc/:CountryRegionId).inner_text,
        :state             => (addr_doc/:State).inner_text,
        :street            => (addr_doc/:Street).inner_text,
        :address_type      => (addr_doc/:type).inner_text
      }
    end
    
    contact_people = []
    (doc/:ContactPerson_1).each do |person|
      contact_people << {
        :email => (person/:Email).inner_text,
        :first_name => (person/:FirstName).inner_text,
        :last_name => (person/:LastName).inner_text,
        :name => (person/:Name).inner_text,
        :selected_address => (person/:selectedAddress).inner_text
      }
    end
    
    return account, addresses, contact_people
  end
  
  def update_record
    begin
      account, addresses, contact_people = fetch_data
      
      # erasure exists date before update record in database
      erasure_record
      
      self.attributes = account
    
      addresses.each {|addr| self.ax_account_addresses << AxAccountAddress.new(addr) }
      contact_people.each {|person| self.ax_account_contact_people << AxAccountContactPerson.new(person) }
      
      save
    rescue
      # if record is new create or never update before.
      # mark record status to "500 ERROR".
      # skip mark record if update successful last time.
      self.update_attribute(:status, "ERROR")
      return false
    end
  end

  # purge data before update
  def erasure_record
    ax_account_addresses.destroy_all unless ax_account_addresses.empty?
    ax_account_contact_people.destroy_all unless ax_account_contact_people.empty?
    self.update_attributes(
      :account_balance               => 0.0,
      :discounts                     => 0.0,
      :currency                      => "",
      :cust_first_name               => "",
      :cust_last_name                => "",
      :email                         => "",
      :cust_group                    => "",
      :language_id                   => "",
      :phone                         => "",
      #:red_one_shipped               => "",
      :address                       => "",
      :city                          => "",
      :country_region_id             => "",
      :state                         => "",
      :street                        => "",
      :tele_prod_tax_exempt          => "",
      :zip_code                      => "",
      :status                        => "ERASURED"
    )
  end
  
  # validation methods
  def record_valid?
    [
      :ax_account_number,
      :address,
      :currency,
      :cust_group,
      :cust_first_name,
      :cust_last_name,
      :email,
      :language_id,
      #:contact_person_name,
      #:contact_person_select_address,
      #:address_1_address
    ].each do |attr|
      if self.send(attr).blank?
        errors.add attr, "#{attr.to_s} can't be blank"
      end
    end

    errors.empty?
  end
  
  def account_balance
    self[:account_balance].blank? ? 0.0 : self[:account_balance]
  end
  
  # methods for business
  def complete_subtotal
    ax_orders.blank? ? 0.0 : ax_orders.map(&:complete_subtotal).inject(&:+)
  end
  
  def available_orders
    ax_orders.find(:all, :conditions => ['sales_status <> ? and sales_status <> ?', 'Canceled', 'Delivered'])
  end
  
  def available_orders_complete_subtotal
    available_orders.blank? ? 0.0 : available_orders.map(&:complete_subtotal).inject(&:+)
  end
  
  # detect store user has already receive redone body.
  def red_one_shipped?
    red_one_shipped == "Yes" ? true : false
  end
  
  # --- short-circuit methods begin --- #
  def email_address
    self.email
  end

  def first_name
    self.cust_first_name
  end
  
  def last_name
    self.cust_last_name
  end

  def name
    "#{first_name} #{last_name}"
  end
  
  def contact_person_email_address
    contact_person = ax_account_master_contact_person
    contact_person ? contact_person.email : "" 
  end
  
  def contact_person_first_name
    contact_person = ax_account_master_contact_person
    contact_person ? contact_person.first_name : ""
  end
  
  def contact_person_last_name
    contact_person = ax_account_master_contact_person
    contact_person ? contact_person.last_name : ""
  end
  
  def contact_person_name
    contact_person = ax_account_master_contact_person
    contact_person ? contact_person.name : ""
  end
  
  def contact_person_selected_address
    contact_person = ax_account_master_contact_person
    contact_person ? contact_person.selected_address : ""
  end
  
  def invoice_address
    invoice_address = ax_account_invoice_address
    invoice_address ? invoice_address.address : address
  end
  
  def invoice_city
    invoice_address = ax_account_invoice_address
    invoice_address ? invoice_address.city : city
  end
  
  def invoice_country_region_id
    invoice_address = ax_account_invoice_address
    invoice_address ? invoice_address.country_region_id : country_region_id
  end
  
  def invoice_state
    invoice_address = ax_account_invoice_address
    invoice_address ? invoice_address.state : state
  end
  
  def invoice_street
    invoice_address = ax_account_invoice_address
    invoice_address ? invoice_address.street : street
  end
  
  def delivery_address
    delivery_address = ax_account_delivery_address
    delivery_address ? delivery_address.address : ""
  end
  
  def delivery_city
    delivery_address = ax_account_delivery_address
    delivery_address ? delivery_address.city : ""
  end
  
  def delivery_country_region_id
    delivery_address = ax_account_delivery_address
    delivery_address ? delivery_address.country_region_id : ""
  end
  
  def delivery_state
    delivery_address = ax_account_delivery_address
    delivery_address ? delivery_address.state : ""
  end
  
  def delivery_street
    delivery_address = ax_account_delivery_address
    delivery_address ? delivery_address.street : ""
  end
  # --- short-circuit methods end --- #
end
