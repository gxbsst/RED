class MailTaskAprNearlyReadyToShipQueueLineItem < ActiveRecord::Base
  include MailTask::General
  belongs_to :mail_task_apr_nearly_ready_to_ship_queue
end

class MailTaskAprNearlyReadyToShipQueue < ActiveRecord::Base
  include MailTask::General
  
  belongs_to :mail_task
  has_many :mail_task_apr_nearly_ready_to_ship_queue_line_items, :dependent => :destroy
  
  Delivery_range_begin = 1501 
  Delivery_range_end   = 1750
  
  DISCOUNT_PRE_CEMERA               = 2500
  SHIPPING_CHARGE_PRE_CEMERA_IN_US  = 185.29
  SHIPPING_CHARGE_PRE_CEMERA_OUT_US = 598.49
  
  # Class methods begin here.
  class << self
     # [
     #      "TRUNCATE #{table_name}",
     #      "TRUNCATE #{line_items_table_name}"
     #    ].each do |statement|
     #      ActiveRecord::Base.connection.execute(statement)
     #    end
    def init_queues
      begin_time = Time.now
      
      # Cleanup all exists records.
      # self.destroy_all
       # Cleanup all exists records.
        [
          "TRUNCATE #{table_name}",
          "TRUNCATE #{line_items_table_name}"
        ].each do |statement|
          connection.execute(statement)
        end
          # Update AxAccount assign_to (#1001 - #1250)
          [
            ['CU 0101417', 'Travis'],
            ['CU 0101433', 'Travis'],
            ['CU 0101457', 'Travis'],
            ['CU 0101424', 'Travis'],
            ['CU 0101416', 'Travis'],
            ['CU 0100153', 'Travis'],
            ['CU 0102838', 'Travis'],
            ['CU 0101206', 'Travis'],
            ['CU 0101439', 'Travis'],
            ['CU 0100753', 'Travis'],
            ['CU 0101440', 'Travis'],
            ['CU 0101420', 'Travis'],
            ['CU 0101209', 'Travis'],
            ['CU 0101432', 'Travis'],
            ['CU 0101210', 'Travis'],
            ['CU 0101211', 'Travis'],
            ['CU 0101207', 'Travis'],
            ['CU 0101458', 'Travis'],
            ['CU 0101213', 'Randy'],
            ['CU 0100414', 'Randy'],
            ['CU 0101212', 'Randy'],
            ['CU 0100193', 'Randy'],
            ['CU 0101216', 'Randy'],
            ['CU 0101427', 'Randy'],
            ['CU 0101220', 'Randy'],
            ['CU 0101219', 'Randy'],
            ['CU 0101221', 'Randy'],
            ['CU 0101222', 'Randy'],
            ['CU 0101223', 'Randy'],
            ['CU 0101224', 'Randy'],
            ['CU 0101225', 'Randy'],
            ['CU 0101421', 'Randy'],
            ['CU 0101226', 'Randy'],
            ['CU 0101227', 'Dan'],
            ['CU 0101228', 'Dan'],
            ['CU 0100749', 'Dan'],
            ['CU 0101231', 'Dan'],
            ['CU 0101437', 'Dan'],
            ['CU 0101232', 'Dan'],
            ['CU 0101428', 'Dan'],
            ['CU 0101475', 'Dan'],
            ['CU 0101233', 'Dan'],
            ['CU 0101234', 'Dan'],
            ['CU 0101235', 'Dan'],
            ['CU 0101423', 'Dan'],
            ['CU 0101236', 'Dan'],
            ['CU 0101238', 'Dan'],
            ['CU 0101239', 'Dan'],
            ['CU 0101286', 'Dan'],
            ['CU 0101270', 'Dan'],
            ['CU 0101242', 'Hoover'],
            ['CU 0101243', 'Hoover'],
            ['CU 0101244', 'Hoover'],
            ['CU 0101245', 'Hoover'],
            ['CU 0101248', 'Hoover'],
            ['CU 0101246', 'Hoover'],
            ['CU 0101250', 'Hoover'],
            ['CU 0101252', 'Hoover'],
            ['CU 0101251', 'Hoover'],
            ['CU 0101264', 'Hoover'],
            ['CU 0101253', 'Hoover'],
            ['CU 0101254', 'Hoover'],
            ['CU 0101229', 'Hoover'],
            ['CU 0101263', 'Hoover'],
            ['CU 0101477', 'Hoover'],
            ['CU 0101478', 'Hoover'],
            ['CU 0101294', 'Hoover'],
            ['CU 0101277', 'Hoover'],
            ['CU 0101218', 'Hoover'],
            ['CU 0101262', 'Hoover'],
            ['CU 0101272', 'Justin'],
            ['CU 0101273', 'Justin'],
            ['CU 0101276', 'Justin'],
            ['CU 0101278', 'Justin'],
            ['CU 0101279', 'Justin'],
            ['CU 0101280', 'Justin'],
            ['CU 0101281', 'Justin'],
            ['CU 0101282', 'Justin'],
            ['CU 0101271', 'Justin'],
            ['CU 0101284', 'Justin'],
            ['CU 0101285', 'Justin'],
            ['CU 0101287', 'Justin'],
            ['CU 0101288', 'Justin'],
            ['CU 0101289', 'Justin'],
            ['CU 0101290', 'Justin'],
            ['CU 0101291', 'Justin'],
            ['CU 0101292', 'Justin'],
            ['CU 0101293', 'Justin'],
            ['CU 0100082', 'Justin'],
            ['CU 0101267', 'Justin'],
            ['CU 0100789', 'Justin'],
            ['CU 0101295', 'Justin'],
            ['CU 0101296', 'Brian'],
            ['CU 0100248', 'Brian'],
            ['CU 0101298', 'Brian'],
            ['CU 0101230', 'Brian'],
            ['CU 0101300', 'Brian'],
            ['CU 0101240', 'Brian'],
            ['CU 0101266', 'Brian'],
            ['CU 0101304', 'Brian'],
            ['CU 0101260', 'Brian'],
            ['CU 0100030', 'Brian'],
            ['CU 0101269', 'Brian'],
            ['CU 0101305', 'Brian'],
            ['CU 0101306', 'Brian'],
            ['CU 0101307', 'Brian'],
            ['CU 0101309', 'Brian'],
            ['CU 0101311', 'Brian'],
            ['CU 0101312', 'Brian'],
            ['CU 0101313', 'Brian'],
            ['CU 0101315', 'Brian'],
            ['CU 0101314', 'Brian'],
            ['CU 0101317', 'Brian'],
            ['CU 0101318', 'Brian'],
            ['CU 0101319', 'Brian'],
            ['CU 0101308', 'Brian'],
            ['CU 0101301', 'Nate'],
            ['CU 0101321', 'Nate'],
            ['CU 0100497', 'Nate'],
            ['CU 0101322', 'Nate'],
            ['CU 0101316', 'Nate'],
            ['CU 0101320', 'Nate'],
            ['CU 0101323', 'Nate'],
            ['CU 0101324', 'Nate'],
            ['CU 0101325', 'Nate'],
            ['CU 0101326', 'Nate'],
            ['CU 0101327', 'Nate'],
            ['CU 0101328', 'Nate'],
            ['CU 0101329', 'Nate'],
            ['CU 0101330', 'Nate'],
            ['CU 0101331', 'Nate'],
            ['CU 0101333', 'Nate'],
            ['CU 0101299', 'Justin'],
            ['CU 0101334', 'Justin'],
            ['CU 0101335', 'Justin'],
            ['CU 0101336', 'Justin'],
            ['CU 0101337', 'Justin'],
            ['CU 0101265', 'Justin'],
            ['CU 0101339', 'Justin'],
            ['CU 0101341', 'Justin'],
            ['CU 0101342', 'Justin'],
            ['CU 0101497', 'Justin'],
            ['CU 0101343', 'Justin'],
            ['CU 0101344', 'Justin'],
            ['CU 0101345', 'Justin'],
            ['CU 0101346', 'Justin'],
            ['CU 0101347', 'Justin'],
            ['CU 0101348', 'Justin'],
            ['CU 0101349', 'Justin'],
            ['CU 0101350', 'Justin'],
            ['CU 0101351', 'Justin'],
            ['CU 0101352', 'Polo'],
            ['CU 0101353', 'Polo'],
            ['CU 0101487', 'Polo'],
            ['CU 0101354', 'Polo'],
            ['CU 0101356', 'Polo'],
            ['CU 0101357', 'Polo'],
            ['CU 0101358', 'Polo'],
            ['CU 0101359', 'Polo'],
            ['CU 0101360', 'Polo'],
            ['CU 0101361', 'Polo'],
            ['CU 0101362', 'Polo'],
            ['CU 0101363', 'Polo'],
            ['CU 0101364', 'Polo'],
            ['CU 0101365', 'Polo'],
            ['CU 0101366', 'Polo'],
            ['CU 0101369', 'Polo'],
            ['CU 0101114', 'Polo'],
            ['CU 0101371', 'Polo']
          ].each do |i|
            account = AxAccount.find_by_ax_account_number(i.first)
            if account
              account.update_attributes(:assign_to => i.last) if (account.assign_to.blank? ||  ! AppConfig.CUSTOMER_STAFF.keys.include?(account.assign_to))
              # account.update_attributes(:assign_to => i.last)
            end
          end
      # get all redone that serial number in the range.
      line_items = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0])
      delivered = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) and remain_sales_physical = ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0]).map(&:sales_item_reservation_number)
      losted = (Delivery_range_begin..Delivery_range_end).map{|i|i.to_s} - line_items.map(&:sales_item_reservation_number) - delivered
      
      # get unique orders which include all lien_items
      orders = line_items.map(&:ax_order).uniq.compact.select do |order|
        if message = order.prepare_delivery_validation
          open("#{RAILS_ROOT}/log/invalid_orders.log", "a+") { |file| file << "#{message}\n" }
          false
        else
          true
        end
      end
      
      # collect all accounts which orders belongs to
      accounts = orders.map(&:ax_account).uniq
      
      # create mail queues
      accounts.each { |account| self.create_queue(account) }
      
      puts %(Redone serial number range: ##{Delivery_range_begin} to ##{Delivery_range_end}.)
      puts %(Delivered Redone serial number: [#{delivered.join(",")}].)
      puts %(Lost Redone serial number: [#{losted.join(",")}].)
      puts %(Amount: #{line_items.size} line_items include redone body.)
      puts %(Amount: #{orders.size} valid and unique orders.)
      puts %(Amount: #{accounts.size} valid and unique accounts.)
      puts %(Amount: #{self.count} records in Mail Queue.)
      puts %(Missing Staff assign to: #{missing_assign_to_list.join(", ")})
      puts %(Use #{Time.now - begin_time} seconds.)
    end
    
    def create_queue(account)
      queue = self.new(
        :ax_account_number               => account.ax_account_number,
        :account_balance                 => account.account_balance,
        :discounts                       => account.discounts,
        :email_address                   => account.email_address,
        :first_name                      => account.first_name,
        :last_name                       => account.last_name,
        :phone                           => account.phone,
        :contact_person_email_address    => account.contact_person_email_address,
        :contact_person_first_name       => account.contact_person_first_name,
        :contact_person_last_name        => account.contact_person_last_name,
        :contact_person_name             => account.contact_person_name,
        :contact_person_selected_address => account.contact_person_selected_address,
        :address                         => account.address,
        :invoice_address                 => account.invoice_address,
        :invoice_city                    => account.invoice_city,
        :invoice_country_region_id       => account.invoice_country_region_id,
        :invoice_state                   => account.invoice_state,
        :invoice_street                  => account.invoice_street,
        :delivery_address                => account.delivery_address,
        :delivery_city                   => account.delivery_city,
        :delivery_country_region_id      => account.delivery_country_region_id,
        :delivery_state                  => account.delivery_state,
        :delivery_street                 => account.delivery_street,
        :assign_to                       => account.assign_to,
        :sid                             => sid_generator
      )
      
      # get all order line items which blongs to account.
      line_items = []
      account.ax_orders.map(&:ax_order_line_items).flatten.each do |line_item|
        # Validation for line item has record in products table.
        if message = line_item.prepare_delivery_validation
          open("#{RAILS_ROOT}/log/invalid_order_line_items.log", "a+") do |file|
            file << "#{message}\n"
          end
          next
        end
        
        line_items << line_items_obj.new(
          :ax_order_number               => line_item.ax_order_number,
          :confirmed_lv                  => line_item.confirmed_lv,
          :delivered_in_total            => line_item.delivered_in_total,
          :invoiced_in_total             => line_item.invoiced_in_total,
          :item_id                       => line_item.item_id,
          :item_name                     => line_item.item_name,
          :remain_sales_physical         => line_item.remain_sales_physical,
          :sales_item_reservation_number => line_item.sales_item_reservation_number,
          :sales_qty                     => line_item.sales_qty,
          :sales_unit                    => line_item.sales_unit,
          :price                         => line_item.price
        )
      end
      
      eval("queue.#{line_items_table_name} = line_items")
      
      queue.save
    end
    
    def missing_assign_to_list
      find(:all).select{|queue| queue.assign_to.blank? || AppConfig.CUSTOMER_STAFF[queue.assign_to].nil? }.map(&:ax_account_number)
    end
    
    def line_items_table_name
      "#{table_name.singularize}_line_items"
    end
    
    def line_items_obj
      ActiveRecord::Base.const_get(line_items_table_name.classify)
    end
  end
  
  # Instance methods begin here.
  def line_items
    @line_items ||= self.send(self.class.line_items_table_name)
  end
  
  def deliverable_redone
    line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number IN (?)', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end)], :order => 'sales_item_reservation_number ASC')
  end
  
  def deliverable_redone_complete?
    deliverable_redone.map(&:remain_sales_physical).inject(&:+) <= 0
  end
  
  def deliverable_redone_quantity
    deliverable_redone.size
  end
  
  def deliverable_redone_unit_price
    17500.0
  end
  
  def deliverable_redone_subtotal
    deliverable_redone_quantity * deliverable_redone_unit_price
  end
  
  def undeliverable_redone
    line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number NOT IN (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0], :order => 'sales_item_reservation_number ASC')
  end
  
  def deliverable_assembly_list
    list = []
    line_items.find(:all, :conditions => ['item_id <> ?', '101001'], :order => 'item_id ASC').each do |line_item|
      # Skip line_item which has already delivered.
      next if line_item.remain_sales_physical <= 0
      
      item = list.find{|i| i.item_id == line_item.item_id}
      if item
        item.remain_sales_physical += line_item.remain_sales_physical
      else
        list << line_item
      end
    end
    return list
  end
  
  def deliverable_assembly
    @deliverable_assembly_list ||= deliverable_assembly_list
  end
  
  def deliverable_assembly_subtotal
    return 0.0 if deliverable_assembly.empty?
    deliverable_assembly.map{ |item| item.price * item.remain_sales_physical }.inject(&:+)
  end
  
  def complete_subtotal
    deliverable_redone_subtotal + deliverable_assembly_subtotal
  end
  
  def deposits
    account_balance.nil? ? 0.0 : account_balance
  end
  
  def available_credits
    deliverable_redone_quantity * DISCOUNT_PRE_CEMERA
  end
  
  def credits
    case
    when deliverable_assembly_subtotal == 0 then 0.0
    when available_credits >= deliverable_assembly_subtotal then deliverable_assembly_subtotal
    else
      available_credits
    end
  end
  
  def all_credited?
    available_credits == credits
  end
  
  def shipping_charges
    if self.delivery_country_region_id == "US"
      deliverable_redone_quantity * SHIPPING_CHARGE_PRE_CEMERA_IN_US
    else
      deliverable_redone_quantity * SHIPPING_CHARGE_PRE_CEMERA_OUT_US
    end
  end
  
  def sales_tax_state_name
    if self.delivery_country_region_id == "US"
      case self.delivery_state
      when "WA" then return "Washington"
      when "CA" then return "California"
      end
    end
    
    return ""
  end
  
  def sales_tax
    tax = 0.0
    if self.delivery_country_region_id == "US"
      case self.delivery_state
      when "WA" then tax = 9.50
      when "CA" then tax = 8.85
      end
    end

    (complete_subtotal - credits) * (tax * 0.01)
  end
  
  def total_due
    complete_subtotal - deposits - credits + shipping_charges + sales_tax
  end
  
  def bill_to_name
    self.name
  end
  
  def bill_to_address
    case
    when !self.invoice_address.blank? then self.invoice_address
    when !self.address.blank? then self.address
    end
  end
  
  def ship_to_name
    case
    when !self.contact_person_name.blank? then self.contact_person_name
    when !self.name.blank? then self.name
    end
  end
  
  def ship_to_address
    case
    when !self.delivery_address.blank? then self.delivery_address
    end
  end
  
  def staff_email_address
    email_address = AppConfig.CUSTOMER_STAFF[assign_to]
    email_address ? email_address : "sales@red.com"
  end
  
  def staff_name_with_email_address
    if AppConfig.CUSTOMER_STAFF[assign_to]
      "#{assign_to} <#{AppConfig.CUSTOMER_STAFF[assign_to]}>"
    else
      "RED <sales@red.com>"
    end
  end
  #需要修改 
  def send_mail
    subject = "Your RED ONE is nearly ready to ship"
    super({:subject => subject, :from => staff_name_with_email_address})
  end
end
