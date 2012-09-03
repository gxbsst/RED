class MailTaskMarReadyToShip2QueueLineItem < ActiveRecord::Base
  include MailTask::MailDB
  belongs_to :mail_task_mar_ready_to_ship2_queue
end

class MailTaskMarReadyToShip2Queue < ActiveRecord::Base
  include MailTask::General
  
  belongs_to :mail_task
  has_many :mail_task_mar_ready_to_ship2_queue_line_items, :dependent => :destroy
  
  Delivery_range_begin = 1251
  Delivery_range_end   = 1500
  
  DISCOUNT_PRE_CEMERA               = 2500
  SHIPPING_CHARGE_PRE_CEMERA_IN_US  = 185.29
  SHIPPING_CHARGE_PRE_CEMERA_OUT_US = 598.49
  
  # Class methods begin here.
  class << self
    def init_queues
      begin_time = Time.now
      
      # Cleanup all exists records.
      [
        "TRUNCATE #{table_name}",
        "TRUNCATE #{line_items_table_name}"
      ].each do |statement|
        ActiveRecord::Base.connection.execute(statement)
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
    line_items.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number IN (?) and remain_sales_physical <> ?', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end), 0], :order => 'sales_item_reservation_number ASC')
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
  
  def send_mail
    subject = "Your RED ONE is nearly ready to ship"
    super({:subject => subject, :from => staff_name_with_email_address})
  end
end