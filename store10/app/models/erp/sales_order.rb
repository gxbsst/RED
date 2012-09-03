class ERP::SalesOrder < ActiveRecord::Base
  include ERPSupport

  belongs_to :customer, :foreign_key => "erp_customer_id"
  has_many :sales_lines, :foreign_key => "erp_sales_order_id", :include => "product", :order => "completed"
  has_many :completed_sales_lines, :foreign_key => "erp_sales_order_id", :include => "product", :conditions => "completed = true", :class_name => "ERP::SalesLine"
  has_many :my_account_logs, :foreign_key => "record_id", :conditions => "class_name = '%{self.class.name}'", :order => "id desc"
  # belongs_to :ship_to_address, :foreign_key => "ship_to_address_id", :class_name => "ERP::Address"
  # belongs_to :bill_to_address, :foreign_key => "bill_to_address_id", :class_name => "ERP::Address"

  has_one :ship_to_address, :foreign_key => "parent_id", :class_name => "ERP::DeliveryAddress"
  has_one :bill_to_address, :foreign_key => "parent_id", :class_name => "ERP::InvoiceAddress"

  # return total price of current sales order
  def total
    sum = 0
    sales_lines.each do |line|
      sum += line.line_amount unless line.line_amount.blank?
    end
    return sum
  end

  def order_number
    if self.sales_id.blank?
       self.purch_order_form_num
    else
      self.sales_id
    end
  end

  def synchronize
    # print "#{self.sales_id} wow this is fun!!!\n"
    response = ERP::ERPAgent.post(
      :url => AppConfig.SOAP_SO_SERV,
      :body => self.class.generate_xml( "read_sales_order", :sales_order => self )
    )

    if response
      # Wrap all changes of current order in a transaction, any failed update will rollback it.
      # If failed, try to append current order object to exception, and then propagate this to
      #   upper stack (usually ERP::Customer#syncronize)
      begin
        self.class.transaction do
          fetch_data( response.body )
          after_synchronize # callback
          update_attribute( :synchronized, true )
        end
        return true
      rescue => exception
        # Dirty code, inject source object to exception
        exception.instance_variable_set( '@source', self )
        raise exception
      end
    end
    
    return false
  end

  def before_save
    # Update status of sales order while save (open/close order)
    self.sales_lines.each do |line|
      if line.remain_sales_physical && line.remain_sales_physical > 0
        self.completed = false
        return
      end
    end

    self.completed = true
  end
  
  # Parsing & fetching data from XML. Calling this method in transaction scope
  def fetch_data( xml )
    doc = Hpricot.XML(xml)

    self.attributes = {
      :purch_order_form_num => (doc/"SalesTable/PurchOrderFormNum").inner_text,
      :sales_status         => (doc/"SalesTable/SalesStatus").inner_text,
      :shipping_charges     => (doc/"SalesTable/ShippingCharges").inner_text,
      :sales_tax            => (doc/"SalesTable/SalesTax").inner_text,
      :synchronized         => false,
      :delivery_mode_id     => (doc/"SalesTable/DlvMode").inner_text,
      :document_status      => (doc/"SalesTable/DocumentStatus").inner_text,
      :erp_modstamp         => ax_modstamp(doc/"SalesTable")
    }
    
    # Following two lines save ax delivery mode and charges to another column
    #   for updating purpose
    # self.ax_delivery_mode_id = self.delivery_mode_id
    # self.ax_shipping_charges = self.shipping_charges
    
    self.save!

    dstreet = (doc/"SalesTable/DeliveryStreet").inner_text
    dcity = (doc/"SalesTable/DeliveryCity").inner_text
    dstate = (doc/"SalesTable/DeliveryState").inner_text
    dzip_code = (doc/"SalesTable/DeliveryZipCode").inner_text
    dcounty = (doc/"SalesTable/DeliveryCounty").inner_text
    dcountry = (doc/"SalesTable/DeliveryCountry").inner_text
    dcountry_region_id = (doc/"SalesTable/DeliveryCountryRegionId").inner_text
    dname = (doc/"SalesTable/DeliveryName").inner_text
    daddress = (doc/"SalesTable/DeliveryAddress").inner_text
    dhash = MD5.md5("#{dstreet}#{dcity}#{dstate}#{dzip_code}#{dcounty}#{dcountry}#{dname}#{daddress}#{dcountry_region_id}")

    self.ship_to_address ||= ERP::DeliveryAddress.new
    if hash.to_s != self.ship_to_address.hash
      self.ship_to_address.attributes = {
        :street => dstreet,
        :city => dcity,
        :state => dstate,
        :zip_code => dzip_code,
        :county => dcounty,
        :country => dcountry,
        :name => dname,
        :address => daddress,
        :country_region_id => dcountry_region_id,
        :hash => dhash.to_s
      }
      self.ship_to_address.save!
    end

    # Create Very Similar Code for the Invoice Address...
    istreet = (doc/"SalesTable/InvoiceStreet").inner_text
    icity = (doc/"SalesTable/InvoiceCity").inner_text
    istate = (doc/"SalesTable/InvoiceState").inner_text
    izip_code = (doc/"SalesTable/InvoiceZipCode").inner_text
    icounty = (doc/"SalesTable/InvoiceCounty").inner_text
    icountry = (doc/"SalesTable/InvoiceCountry").inner_text
    iname = (doc/"SalesTable/InvoiceName").inner_text
    iaddress = (doc/"SalesTable/InvoiceAddress").inner_text
    icountry_region_id = (doc/"SalesTable/InvoiceCountryRegionId").inner_text
    ihash = MD5.md5("#{istreet}#{icity}#{istate}#{izip_code}#{icounty}#{icountry}#{iname}#{iaddress}#{icountry_region_id}")

    self.bill_to_address ||= ERP::InvoiceAddress.new
    if hash.to_s != self.bill_to_address.hash
      self.bill_to_address.attributes = {
        :street => istreet,
        :city => icity,
        :state => istate,
        :zip_code => izip_code,
        :county => icounty,
        :country => icountry,
        :name => iname,
        :address => iaddress,
        :country_region_id => icountry_region_id,
        :hash => ihash.to_s
      }
      self.bill_to_address.save!
    end

    # Sales Order Line Items
    self.sales_lines.clear # :dependent => :delete_all
    (doc/"SalesTable/SalesLine").each do |node|
      output_log "[B] Sales Order: #{sales_id}: #{(node/'ItemId').inner_text} X #{(node/'SalesQty').inner_text}"
      line = self.sales_lines.create(
        :confirmed_dlv => (node/'ConfirmedDlv').inner_text,
        :item_id => (node/'ItemId').inner_text,
        :sales_item_reservation_number => (node/'SalesItemReservationNumber').inner_text,
        :sales_qty => (node/'SalesQty').inner_text,
        :sales_unit => (node/'SalesUnit').inner_text,
        :remain_sales_physical => (node/'RemainSalesPhysical').inner_text.to_i,
        :delivered_in_total => (node/'DeliveredInTotal').inner_text,
        :invoiced_in_total => (node/'InvoicedInTotal').inner_text,
        :invent_trans_id => (node/'InventTransId').inner_text,
        :line_amount => (node/'LineAmount').inner_text,
        :sales_price => (node/'SalesPrice').inner_text,
        :line_percent => (node/'LinePercent').inner_text
      )
      line.save!
      # pp line
    end
    
    # Save again to re-calc order's status
    self.save!
  end

  # Moving a sales line to another open order.
  #   1. Delivered products will still remain in the orignial order.
  #   2. Sales lines that refer to a RED ONE Body can not be merged.
  #   3. Merging undelivered sales lines by adding their sales quantity.
  def move_sales_line( sales_line_id, target_order_id )
    sales_line = self.sales_lines.find sales_line_id
    target_order = self.customer.sales_orders.find target_order_id

    moving_qty = sales_line.remain_sales_physical
    if moving_qty.zero?
      self.errors.add :sales_lines, "This sales line has been fully completed."
      return false
    end

    self.class.transaction( sales_line ) do
      # Move out sales line from original order
      sales_line.sales_qty -= moving_qty
      sales_line.remain_sales_physical -= moving_qty
      sales_line.save!
      self.mark_as_modified

      # Append sales_line to target order
      existing_line = target_order.sales_lines.find_by_item_id sales_line.item_id
      if existing_line.nil?
        target_order.sales_lines.create! :sales_qty => moving_qty, :item_id => sales_line.item_id
      else
        existing_line.sales_qty += moving_qty
        existing_line.remain_sales_physical += moving_qty
        existing_line.save!
      end
      target_order.mark_as_modified
    end
  end

  # Mark as modified
  # This method should be called after changes from client
  def mark_as_modified
    update_attribute :synchronized, false
  end

  # Commit changes to AX Server
  def commit
    self.class.commit_orders [self]
  end

  def self.commit_orders( orders )
    ### RYAN TODO
    # 1 Verify that the Sales Orders have not been modified in AX since the last upload
    # 2 If it was modified, then throw an error out here!!!

    response = ERPAgent.enqueue(
      :url => AppConfig.SOAP_SO_UPDATE_SERV,
      :body => generate_xml( "create_list_sales_order_update", :orders => orders )
    )

    ERP::SalesOrder.update_all "synchronized = true", ["id in (?)", orders.collect{|order| order.id}]

    return response
  end
  
  # Return the calculated available freights for current sales order.
  # Note:
  #   Return an Array contains delivery mode code and retail price, looks like
  #   [['FdxIp', '123.45'], ['FdxGr', '98.76']]
  def available_freight_options( force_reload=false )
    return @available_freight_options unless force_reload || @available_freight_options.nil?
    
    @available_freight_options = AxShippingRate.find(
      :all,
      :conditions => ["shipping_zone = ? AND (? BETWEEN min_points AND max_points)", fedex_zone, shipping_points],
      :order => 'retail_price'
    ).collect{ |rate| [rate.code, rate.retail_price] }
    
    # Mode excepts FedEx are only visible if order's delivery mode is other values in AX.
    # In this case, customer CAN NOT change their delivery mode back to others (ex. WC) after they
    #   switch it to FedEx and commit changes to AX.
    unless self.ax_delivery_mode_id =~ /^Fdx.+$/
      @available_freight_options.unshift( [self.ax_delivery_mode_id, self.ax_shipping_charges] )
    end
    
    return @available_freight_options
  end
  
  # Fedex Zone Code
  def fedex_zone
    Country.find_by_fedex_code(ship_to_address.country_region_id).fedex_zone
  end
  
  # Total shipping points of all lines under this order.
  def shipping_points
    AxInventory.sum(
      "shipping_points",
      :joins => "RIGHT JOIN erp_sales_lines ON erp_sales_lines.item_id = ax_inventories.item_id",
      :conditions => ["erp_sales_lines.erp_sales_order_id = ?", self.id]
    )
  end

  private

  def mark_rush_order
  end
  
  def after_synchronize
    scan_serials_for_item('101001') # scan for newly created sales line of RED ONE
  end
  
  # Scan sales lines for detecting products' serial numbers with special item id. If found, add them
  # into Serial Number table. After that, calling ERP::Customer#deliver_serial_number_notifications
  # to deliver these notification mails to purchasers.
  def scan_serials_for_item( item_id )
    self.sales_lines.each do |line|
      
      # Skip to next unless the item id is matched and serial number is not blank
      # TODO:
      # Recognize changes of this serial number (RETURNED / CANCELED / BACKORDER / NONE)
      next unless (line.item_id == item_id) && (line.sales_item_reservation_number?)
      
      ERP::SerialNumber.find_or_create(
        :account_num => self.customer.account_num,
        :item_id => item_id,
        :sales_id => self.sales_id,
        :serial => line.sales_item_reservation_number
      )
    end
  end
  
end
