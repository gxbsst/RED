class MailTaskApr2NearlyReadyToShipQueueLineItem < ActiveRecord::Base
  include MailTask::General
  belongs_to :mail_task_apr2_nearly_ready_to_ship_queue
end

class MailTaskApr2NearlyReadyToShipQueue < ActiveRecord::Base
  include MailTask::General
  
  belongs_to :mail_task
  has_many :mail_task_apr2_nearly_ready_to_ship_queue_line_items, :dependent => :destroy
  
  Delivery_range_begin = 1751 
  Delivery_range_end   = 2000
  
  DISCOUNT_PRE_CEMERA               = 0
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
            ['CU 0101371', 'Polo'],
            ['CU 0101372', 'Dan'],
            ['CU 0101375', 'Dan'],
            ['CU 0101376', 'Dan'],
            ['CU 0101377', 'Dan'],
            ['CU 0101378', 'Dan'],
            ['CU 0101379', 'Dan'],
            ['CU 0101381', 'Dan'],
            ['CU 0101382', 'Dan'],
            ['CU 0100527', 'Dan'],
            ['CU 0101384', 'Dan'],
            ['CU 0101385', 'Dan'],
            ['CU 0101387', 'Dan'],
            ['CU 0101389', 'Dan'],
            ['CU 0101390', 'Dan'],
            ['CU 0101392', 'Dan'],
            ['CU 0101393', 'Dan'],
            ['CU 0101394', 'Dan'],
            ['CU 0101395', 'Dan'],
            ['CU 0101396', 'Dan'],
            ['CU 0101398', 'Dan'],
            ['CU 0101401', 'Dan'],
            ['CU 0101402', 'Dan'],
            ['CU 0101403', 'Dan'],
            ['CU 0101404', 'Dan'],
            ['CU 0101341', 'Dan'],
            ['CU 0101406', 'Dan'],
            ['CU 0101408', 'Dan'],
            ['CU 0101409', 'Dan'],
            ['CU 0101410', 'Dan'],
            ['CU 0101268', 'Dan'],
            ['CU 0101411', 'Dan'],
            ['CU 0101415', 'Restivo'],
            ['CU 0101419', 'Restivo'],
            ['CU 0101485', 'Restivo'],
            ['CU 0101422', 'Restivo'],
            ['CU 0102322', 'Restivo'],
            ['CU 0101425', 'Restivo'],
            ['CU 0101430', 'Restivo'],
            ['CU 0101431', 'Restivo'],
            ['CU 0101435', 'Restivo'],
            ['CU 0101441', 'Restivo'],
            ['CU 0101444', 'Restivo'],
            ['CU 0101446', 'Restivo'],
            ['CU 0101447', 'Restivo'],
            ['CU 0101448', 'Restivo'],
            ['CU 0101449', 'Restivo'],
            ['CU 0101525', 'Restivo'],
            ['CU 0101450', 'Restivo'],
            ['CU 0101452', 'Restivo'],
            ['CU 0101453', 'Restivo'],
            ['CU 0101454', 'Restivo'],
            ['CU 0100630', 'Restivo'],
            ['CU 0101455', 'Restivo'],
            ['CU 0101456', 'Restivo'],
            ['CU 0101459', 'Restivo'],
            ['CU 0101460', 'Restivo'],
            ['CU 0101461', 'Restivo'],
            ['CU 0101462', 'Restivo'],
            ['CU 0101463', 'Restivo'],
            ['CU 0101467', 'Restivo'],
            ['CU 0101468', 'Restivo'],
            ['CU 0100772', 'Travis'],
            ['CU 0101469', 'Travis'],
            ['CU 0101470', 'Travis'],
            ['CU 0101471', 'Travis'],
            ['CU 0101473', 'Travis'],
            ['CU 0101474', 'Travis'],
            ['CU 0101476', 'Travis'],
            ['CU 0101479', 'Travis'],
            ['CU 0101480', 'Travis'],
            ['CU 0101481', 'Travis'],
            ['CU 0101482', 'Travis'],
            ['CU 0101483', 'Travis'],
            ['CU 0101484', 'Travis'],
            ['CU 0101486', 'Travis'],
            ['CU 0100706', 'Travis'],
            ['CU 0101100', 'Travis'],
            ['CU 0101488', 'Travis'],
            ['CU 0101489', 'Travis'],
            ['CU 0101490', 'Travis'],
            ['CU 0101491', 'Travis'],
            ['CU 0101552', 'Travis'],
            ['CU 0101493', 'Justin'],
            ['CU 0101494', 'Justin'],
            ['CU 0101496', 'Justin'],
            ['CU 0101498', 'Justin'],
            ['CU 0101499', 'Justin'],
            ['CU 0101500', 'Justin'],
            ['CU 0101501', 'Justin'],
            ['CU 0101521', 'Justin'],
            ['CU 0101502', 'Justin'],
            ['CU 0101505', 'Justin'],
            ['CU 0101506', 'Justin'],
            ['CU 0101507', 'Justin'],
            ['CU 0101508', 'Justin'],
            ['CU 0101509', 'Justin'],
            ['CU 0101510', 'Justin'],
            ['CU 0101511', 'Justin'],
            ['CU 0101512', 'Justin'],
            ['CU 0101513', 'Justin'],
            ['CU 0101514', 'Justin'],
            ['CU 0101515', 'Justin'],
            ['CU 0101516', 'Justin'],
            ['CU 0101517', 'Justin'],
            ['CU 0101518', 'Justin'],
            ['CU 0101519', 'Justin'],
            ['CU 0101520', 'Justin'],
            ['CU 0101522', 'Polo'],
            ['CU 0101523', 'Polo'],
            ['CU 0101526', 'Polo'],
            ['CU 0101527', 'Polo'],
            ['CU 0100500', 'Polo'],
            ['CU 0103075', 'Polo'],
            ['CU 0101195', 'Polo'],
            ['CU 0101531', 'Polo'],
            ['CU 0101533', 'Polo'],
            ['CU 0101534', 'Polo'],
            ['CU 0101536', 'Polo'],
            ['CU 0101537', 'Polo'],
            ['CU 0101539', 'Polo'],
            ['CU 0101540', 'Polo'],
            ['CU 0101541', 'Polo'],
            ['CU 0101542', 'Polo'],
            ['CU 0101543', 'Polo'],
            ['CU 0101544', 'Polo'],
            ['CU 0101545', 'Polo'],
            ['CU 0101546', 'Polo'],
            ['CU 0101547', 'Polo'],
            ['CU 0101548', 'Polo'],
            ['CU 0101549', 'Polo'],
            ['CU 0101550', 'Polo'],
            ['CU 0101551', 'Polo'],
            ['CU 0101553', 'Polo'],
            ['CU 0101554', 'Polo'],
            ['CU 0101555', 'Polo'],
            ['CU 0101556', 'Nate'],
            ['CU 0101557', 'Nate'],
            ['CU 0101558', 'Nate'],
            ['CU 0101559', 'Nate'],
            ['CU 0101560', 'Nate'],
            ['CU 0101561', 'Nate'],
            ['CU 0101562', 'Nate'],
            ['CU 0101563', 'Nate'],
            ['CU 0101564', 'Nate'],
            ['CU 0101565', 'Nate'],
            ['CU 0101566', 'Nate'],
            ['CU 0101567', 'Nate'],
            ['CU 0101569', 'Nate'],
            ['CU 0101571', 'Nate'],
            ['CU 0101573', 'Nate'],
            ['CU 0101575', 'Nate'],
            ['CU 0101576', 'Nate'],
            ['CU 0101572', 'Nate'],
            ['CU 0101578', 'Nate'],
            ['CU 0101579', 'Nate'],
            ['CU 0101580', 'Nate'],
            ['CU 0101581', 'Nate'],
            ['CU 0100615', 'Nate'],
            ['CU 0100515', 'Nate'],
            ['CU 0101582', 'Hoover'],
            ['CU 0101584', 'Hoover'],
            ['CU 0101585', 'Hoover'],
            ['CU 0101588', 'Hoover'],
            ['CU 0101589', 'Hoover'],
            ['CU 0101590', 'Hoover'],
            ['CU 0101592', 'Hoover'],
            ['CU 0101593', 'Hoover'],
            ['CU 0101594', 'Hoover'],
            ['CU 0101595', 'Hoover'],
            ['CU 0101596', 'Hoover'],
            ['CU 0101388', 'Hoover'],
            ['CU 0101599', 'Hoover'],
            ['CU 0101600', 'Hoover'],
            ['CU 0101601', 'Hoover'],
            ['CU 0101604', 'Hoover'],
            ['CU 0101605', 'Hoover'],
            ['CU 0101606', 'Hoover'],
            ['CU 0101607', 'Hoover'],
            ['CU 0101608', 'Hoover'],
            ['CU 0101610', 'Hoover'],
            ['CU 0101611', 'Hoover'],
            ['CU 0101612', 'Hoover'],
            ['CU 0101613', 'Hoover'],
            ['CU 0101614', 'Hoover'],
            ['CU 0101615', 'Hoover'],
            ['CU 0101616', 'Randy'],
            ['CU 0101617', 'Randy'],
            ['CU 0101618', 'Randy'],
            ['CU 0101619', 'Randy'],
            ['CU 0101620', 'Randy'],
            ['CU 0101621', 'Randy'],
            ['CU 0101622', 'Randy'],
            ['CU 0101623', 'Randy'],
            ['CU 0101624', 'Randy'],
            ['CU 0101625', 'Randy'],
            ['CU 0101626', 'Randy'],
            ['CU 0101627', 'Randy'],
            ['CU 0101629', 'Randy'],
            ['CU 0101630', 'Randy'],
            ['CU 0101632', 'Randy'],
            ['CU 0101633', 'Randy'],
            ['CU 0101634', 'Randy'],
            ['CU 0101635', 'Randy'],
            ['CU 0101253', 'Randy']
          ].each do |i|
            account = AxAccount.find_by_ax_account_number(i.first)
            if account
              account.update_attributes(:assign_to => i.last)  if account.assign_to.blank?
              # account.update_attributes(:assign_to => i.last) if account.assign_to.blank?
              # account.update_attributes(:assign_to => i.last) if (account.assign_to.blank? ||  ! AppConfig.CUSTOMER_STAFF.keys.include?(account.assign_to))
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
