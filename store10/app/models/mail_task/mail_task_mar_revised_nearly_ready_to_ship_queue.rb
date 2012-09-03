class MailTaskMarRevisedNearlyReadyToShipQueueLineItem < ActiveRecord::Base
  include MailTask::MailDB
  belongs_to :mail_task_mar_revised_nearly_ready_to_ship_queue
end

class MailTaskMarRevisedNearlyReadyToShipQueue < ActiveRecord::Base
  include MailTask::General
  
  belongs_to :mail_task
  has_many :mail_task_mar_revised_nearly_ready_to_ship_queue_line_items, :dependent => :destroy
  
  Delivery_range_begin = 1001
  Delivery_range_end   = 1250
  
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
      
      MailTaskMarNearlyReadyToShipQueueLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number < ? and remain_sales_physical = ?', Product::REDONE_ERP_PRODUCT_ITEM, Delivery_range_begin, 0], :order => 'sales_item_reservation_number ASC').each do |queue_item|
        original_queue = queue_item.mail_task_mar_nearly_ready_to_ship_queue
        original_items = original_queue.mail_task_mar_nearly_ready_to_ship_queue_line_items
        queue = self.new(
          :ax_account_number             => original_queue.ax_account_number,
          :account_balance               => original_queue.account_balance,
          :discounts                     => original_queue.discounts,
          :email_address                 => original_queue.email_address,
          :first_name                    => original_queue.first_name,
          :last_name                     => original_queue.last_name,
          :phone                         => original_queue.phone,
          :contact_person_name           => original_queue.contact_person_name,
          :contact_person_select_address => original_queue.contact_person_select_address,
          :address                       => original_queue.address,
          :invoice_address               => original_queue.invoice_address,
          :invoice_city                  => original_queue.invoice_city,
          :invoice_country_region_id     => original_queue.invoice_country_region_id,
          :invoice_state                 => original_queue.invoice_state,
          :invoice_street                => original_queue.invoice_street,
          :delivery_address              => original_queue.delivery_address,
          :delivery_city                 => original_queue.delivery_city,
          :delivery_country_region_id    => original_queue.delivery_country_region_id,
          :delivery_state                => original_queue.delivery_state,
          :delivery_street               => original_queue.delivery_street,
          :assign_to                     => original_queue.assign_to,
          :sid                           => sid_generator
        )
        
        line_items = []
        original_items.each do |item|
          line_items << line_items_obj.new(
            :ax_order_number               => item.ax_order_number,
            :confirmed_lv                  => item.confirmed_lv,
            :delivered_in_total            => item.delivered_in_total,
            :invoiced_in_total             => item.invoiced_in_total,
            :item_id                       => item.item_id,
            :item_name                     => item.item_name,
            :remain_sales_physical         => item.remain_sales_physical,
            :sales_item_reservation_number => item.sales_item_reservation_number,
            :sales_qty                     => item.sales_qty,
            :sales_unit                    => item.sales_unit,
            :price                         => item.price
          )
        end
        
        eval("queue.#{line_items_table_name} = line_items")
      
        queue.save
      end
      
      puts %(Redone serial number range: ##{Delivery_range_begin} to ##{Delivery_range_end}.)
      puts %(Amount: #{self.count} records in Mail Queue.)
      puts %(Use #{Time.now - begin_time} seconds.)
    end
    
    def create_queue(account)
      queue = self.new(
        :ax_account_number             => account.ax_account_number,
        :account_balance               => account.account_balance,
        :discounts                     => account.discounts,
        :email_address                 => account.email_address,
        :first_name                    => account.first_name,
        :last_name                     => account.last_name,
        :phone                         => account.phone,
        :contact_person_name           => account.contact_person_name,
        :contact_person_select_address => account.contact_person_select_address,
        :address                       => account.address,
        :invoice_address               => account.invoice_address,
        :invoice_city                  => account.invoice_city,
        :invoice_country_region_id     => account.invoice_country_region_id,
        :invoice_state                 => account.invoice_state,
        :invoice_street                => account.invoice_street,
        :delivery_address              => account.delivery_address,
        :delivery_city                 => account.delivery_city,
        :delivery_country_region_id    => account.delivery_country_region_id,
        :delivery_state                => account.delivery_state,
        :delivery_street               => account.delivery_street,
        :assign_to                     => account.assign_to,
        :sid                           => sid_generator
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
    when deliverable_assembly_subtotal == 0 : 0.0
    when available_credits >= deliverable_assembly_subtotal : deliverable_assembly_subtotal
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
      when "WA" : return "Washington"
      when "CA" : return "California"
      end
    end
    
    return ""
  end
  
  def sales_tax
    tax = 0.0
    if self.delivery_country_region_id == "US"
      case self.delivery_state
      when "WA" : tax = 9.50
      when "CA" : tax = 8.85
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
    when !self.invoice_address.blank? : self.invoice_address
    when !self.address.blank? : self.address
    end
  end
  
  def ship_to_name
    case
    when !self.contact_person_name.blank? : self.contact_person_name
    when !self.name.blank? : self.name
    end
  end
  
  def ship_to_address
    case
    when !self.delivery_address.blank? : self.delivery_address
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
    subject = "REVISED: Your RED ONE is nearly ready to ship"
    super({:subject => subject, :from => staff_name_with_email_address})
  end
end