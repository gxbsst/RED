class MailTaskAugNearlyReadyToShipQueueLineItem < ActiveRecord::Base
  include MailTask::General
  belongs_to :mail_task_aug_nearly_ready_to_ship_queue
end

class MailTaskAugNearlyReadyToShipQueue < ActiveRecord::Base
  belongs_to :mail_task
  include MailTask::General
  has_many :mail_task_aug_nearly_ready_to_ship_queue_line_items, :dependent => :destroy
    Delivery_range_begin = 2401
    Delivery_range_end   = 2650

    DISCOUNT_PRE_CEMERA = 0
    
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
              [ 'CU 0101969', 'Randy'],
              [ 'CU 0101970', 'Randy'],
              [ 'CU 0101971', 'Randy'],
              [ 'CU 0100187', 'Randy'],
              [ 'CU 0101884', 'Randy'],
              [ 'CU 0101972', 'Randy'],
              [ 'CU 0101974', 'Randy'],
              [ 'CU 0101975', 'Randy'],
              [ 'CU 0101976', 'Randy'],
              [ 'CU 0100201', 'Randy'],
              [ 'CU 0101977', 'Randy'],
              [ 'CU 0101978', 'Randy'],
              [ 'CU 0101979', 'Randy'],
              [ 'CU 0101982', 'Randy'],
              [ 'CU 0101983', 'Randy'],
              [ 'CU 0101984', 'Randy'],
              [ 'CU 0101986', 'Randy'],
              [ 'CU 0101913', 'Randy'],
              [ 'CU 0101987', 'Randy'],
              [ 'CU 0101988', 'Randy'],
              [ 'CU 0101989', 'Randy'],
              [ 'CU 0101990', 'Randy'],
              [ 'CU 0101991', 'Randy'],
              [ 'CU 0101993', 'Randy'],
              [ 'CU 0101992', 'Randy'],
              [ 'CU 0101994', 'Randy'],
              [ 'CU 0101995', 'Randy'],
              [ 'CU 0101996', 'Randy'],
              [ 'CU 0102001', 'Justin'],
              [ 'CU 0102004', 'Justin'],
              [ 'CU 0101744', 'Justin'],
              [ 'CU 0102005', 'Justin'],
              [ 'CU 0102006', 'Justin'],
              [ 'CU 0102007', 'Justin'],
              [ 'CU 0102010', 'Justin'],
              [ 'CU 0102012', 'Justin'],
              [ 'CU 0102013', 'Justin'],
              [ 'CU 0102014', 'Justin'],
              [ 'CU 0102015', 'Justin'],
              [ 'CU 0102016', 'Justin'],
              [ 'CU 0102017', 'Justin'],
              [ 'CU 0102019', 'Justin'],
              [ 'CU 0102020', 'Justin'],
              [ 'CU 0102021', 'Justin'],
              [ 'CU 0102023', 'Justin'],
              [ 'CU 0102022', 'Justin'],
              [ 'CU 0101515', 'Justin'],
              [ 'CU 0102026', 'Justin'],
              [ 'CU 0102027', 'Justin'],
              [ 'CU 0102031', 'Justin'],
              [ 'CU 0102033', 'Justin'],
              [ 'CU 0102034', 'Justin'],
              [ 'CU 0102035', 'Justin'],
              [ 'CU 0102036', 'Justin'],
              [ 'CU 0102037', 'Justin'],
              [ 'CU 0102038', 'Justin'],
              [ 'CU 0102039', 'Justin'],
              [ 'CU 0102040', 'Justin'],
              [ 'CU 0102041', 'Justin'],
              [ 'CU 0102043', 'Justin'],
              [ 'CU 0102044', 'Justin'],
              [ 'CU 0100861', 'Justin'],
              [ 'CU 0102046', 'Chad'],
              [ 'CU 0101818', 'Chad'],
              [ 'CU 0102047', 'Chad'],
              [ 'CU 0102048', 'Chad'],
              [ 'CU 0101555', 'Chad'],
              [ 'CU 0102049', 'Chad'],
              [ 'CU 0102050', 'Chad'],
              [ 'CU 0102051', 'Chad'],
              [ 'CU 0102052', 'Chad'],
              [ 'CU 0101527', 'Chad'],
              [ 'CU 0102053', 'Chad'],
              [ 'CU 0101506', 'Chad'],
              [ 'CU 0102054', 'Chad'],
              [ 'CU 0102055', 'Chad'],
              [ 'CU 0102056', 'Chad'],
              [ 'CU 0100444', 'Chad'],
              [ 'CU 0102057', 'Chad'],
              [ 'CU 0102058', 'Chad'],
              [ 'CU 0102060', 'Chad'],
              [ 'CU 0102059', 'Chad'],
              [ 'CU 0102066', 'Chad'],
              [ 'CU 0102067', 'Chad'],
              [ 'CU 0102068', 'Chad'],
              [ 'CU 0102069', 'Chad'],
              [ 'CU 0102071', 'Chad'],
              [ 'CU 0102072', 'Chad'],
              [ 'CU 0102073', 'Chad'],
              [ 'CU 0100647', 'Travis'],
              [ 'CU 0102074', 'Polo'],
              [ 'CU 0102075', 'Polo'],
              [ 'CU 0102078', 'Polo'],
              [ 'CU 0102079', 'Polo'],
              [ 'CU 0102080', 'Polo'],
              [ 'CU 0102081', 'Polo'],
              [ 'CU 0102082', 'Polo'],
              [ 'CU 0102083', 'Polo'],
              [ 'CU 0102085', 'Polo'],
              [ 'CU 0102086', 'Polo'],
              [ 'CU 0102087', 'Polo'],
              [ 'CU 0102089', 'Polo'],
              [ 'CU 0102090', 'Polo'],
              [ 'CU 0102091', 'Polo'],
              [ 'CU 0102092', 'Polo'],
              [ 'CU 0102093', 'Polo'],
              [ 'CU 0102094', 'Polo'],
              [ 'CU 0102095', 'Polo'],
              [ 'CU 0102096', 'Polo'],
              [ 'CU 0102097', 'Polo'],
              [ 'CU 0102099', 'Polo'],
              [ 'CU 0102025', 'Polo'],
              [ 'CU 0102100', 'Polo'],
              [ 'CU 0102101', 'Polo'],
              [ 'CU 0102103', 'Polo'],
              [ 'CU 0102104', 'Restivo'],
              [ 'CU 0102105', 'Restivo'],
              [ 'CU 0102106', 'Restivo'],
              [ 'CU 0102108', 'Restivo'],
              [ 'CU 0102109', 'Restivo'],
              [ 'CU 0102110', 'Restivo'],
              [ 'CU 0102111', 'Restivo'],
              [ 'CU 0102112', 'Restivo'],
              [ 'CU 0100648', 'Restivo'],
              [ 'CU 0102113', 'Restivo'],
              [ 'CU 0102114', 'Restivo'],
              [ 'CU 0100587', 'Restivo'],
              [ 'CU 0102116', 'Restivo'],
              [ 'CU 0102118', 'Restivo'],
              [ 'CU 0102119', 'Restivo'],
              [ 'CU 0102120', 'Restivo'],
              [ 'CU 0102121', 'Restivo'],
              [ 'CU 0102122', 'Restivo'],
              [ 'CU 0102123', 'Restivo'],
              [ 'CU 0102124', 'Restivo'],
              [ 'CU 0102125', 'Restivo'],
              [ 'CU 0102126', 'Restivo'],
              [ 'CU 0102127', 'Restivo'],
              [ 'CU 0102128', 'Restivo'],
              [ 'CU 0102129', 'Restivo'],
              [ 'CU 0102130', 'Restivo'],
              [ 'CU 0100181', 'Restivo'],
              [ 'CU 0102131', 'Restivo'],
              [ 'CU 0102132', 'Restivo'],
              [ 'CU 0102133', 'Restivo'],
              [ 'CU 0102134', 'Restivo'],
              [ 'CU 0102136', 'Dan'],
              [ 'CU 0102137', 'Dan'],
              [ 'CU 0102138', 'Dan'],
              [ 'CU 0102139', 'Dan'],
              [ 'CU 0102140', 'Dan'],
              [ 'CU 0102141', 'Dan'],
              [ 'CU 0102143', 'Dan'],
              [ 'CU 0102144', 'Dan'],
              [ 'CU 0102145', 'Dan'],
              [ 'CU 0102146', 'Dan'],
              [ 'CU 0101114', 'Dan'],
              [ 'CU 0102147', 'Dan'],
              [ 'CU 0102149', 'Dan'],
              [ 'CU 0102150', 'Travis'],
              [ 'CU 0102151', 'Travis'],
              [ 'CU 0102152', 'Travis'],
              [ 'CU 0102153', 'Travis'],
              [ 'CU 0102154', 'Travis'],
              [ 'CU 0102155', 'Travis'],
              [ 'CU 0100324', 'Travis'],
              [ 'CU 0102156', 'Travis'],
              [ 'CU 0102157', 'Travis'],
              [ 'CU 0102159', 'Travis'],
              [ 'CU 0102160', 'Travis'],
              [ 'CU 0102161', 'Travis'],
              [ 'CU 0102162', 'BrianB'],
              [ 'CU 0102163', 'BrianB'],
              [ 'CU 0102164', 'BrianB'],
              [ 'CU 0102165', 'BrianB'],
              [ 'CU 0102166', 'BrianB'],
              [ 'CU 0101964', 'BrianB'],
              [ 'CU 0102169', 'BrianB'],
              [ 'CU 0101122', 'BrianB'],
              [ 'CU 0102171', 'BrianB'],
              [ 'CU 0102172', 'BrianB'],
              [ 'CU 0102173', 'BrianB'],
              [ 'CU 0102174', 'BrianB'],
              [ 'CU 0102175', 'BrianB'],
              [ 'CU 0102176', 'BrianB']
            ].each do |i|
              
              unless  AppConfig.CUSTOMER_STAFF[i.last]
                puts "========================================================>"
                puts "No the Email of #{i.last} !"
                puts "========================================================>"
                exit
              end
              
              account = AxAccount.find_by_ax_account_number(i.first)
              if account
                account.update_attributes(:assign_to => i.last)  if account.assign_to.blank? || account.assign_to == 'Nate' || account.assign_to == 'Sean'
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
        # accounts.each { |account| self.create_queue(account)  } 
        accounts.each { |account| self.create_queue(account) unless (account.ax_account_number == 'CU 0102000' || account.ax_account_number == 'CU 0102142' || account.ax_account_number == 'CU 0100005') } 
        

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
      self.ax_account_number == 'CU 0101122' ? credits = 2500 : credits = 0
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
