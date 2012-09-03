class MailTaskJuneReadyToShipQueueLineItem < ActiveRecord::Base
  include MailTask::General
  belongs_to :mail_task_june_ready_to_ship_queue
end

class MailTaskJuneReadyToShipQueue < ActiveRecord::Base
  belongs_to :mail_task
  include MailTask::General
  has_many :mail_task_june_ready_to_ship_queue_line_items, :dependent => :destroy
    Delivery_range_begin = 2001 
    Delivery_range_end   = 2100

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
              ['CU 0101636', 'Restivo'],
              ['CU 0101637', 'Restivo'],
              ['CU 0101638', 'Restivo'],
              ['CU 0101639', 'Restivo'],
              ['CU 0101640', 'Restivo'],
              ['CU 0101641', 'Restivo'],
              ['CU 0101580', 'Restivo'],
              ['CU 0101642', 'Restivo'],
              ['CU 0101643', 'Restivo'],
              ['CU 0101377', 'Restivo'],
              ['CU 0101645', 'Restivo'],
              ['CU 0101646', 'Restivo'],
              ['CU 0101647', 'Restivo'],
              ['CU 0101648', 'Restivo'],
              ['CU 0101649', 'Restivo'],
              ['CU 0101650', 'Restivo'],
              ['CU 0101651', 'Restivo'],
              ['CU 0101653', 'Restivo'],
              ['CU 0101654', 'Restivo'],
              ['CU 0101655', 'Restivo'],
              ['CU 0101632', 'Restivo'],
              ['CU 0101657', 'Restivo'],
              ['CU 0101658', 'Restivo'],
              ['CU 0101659', 'Polo'],
              ['CU 0101660', 'Polo'],
              ['CU 0101661', 'Polo'],
              ['CU 0101662', 'Polo'],
              ['CU 0101663', 'Polo'],
              ['CU 0101664', 'Polo'],
              ['CU 0101665', 'Polo'],
              ['CU 0101666', 'Polo'],
              ['CU 0101667', 'Polo'],
              ['CU 0101668', 'Polo'],
              ['CU 0101670', 'Polo'],
              ['CU 0101671', 'Polo'],
              ['CU 0101673', 'Polo'],
              ['CU 0101675', 'Polo'],
              ['CU 0101676', 'Polo'],
              ['CU 0101448', 'Polo'],
              ['CU 0101677', 'Polo'],
              ['CU 0101678', 'Polo'],
              ['CU 0101679', 'Polo'],
              ['CU 0101680', 'Polo'],
              ['CU 0100449', 'Polo'],
              ['CU 0101681', 'Polo'],
              ['CU 0101682', 'Polo'],
              ['CU 0101683', 'Polo'],
              ['CU 0101684', 'Polo'],
              ['CU 0101685', 'Polo'],
              ['CU 0101631', 'Polo'],
              ['CU 0101686', 'Travis'],
              ['CU 0101687', 'Travis'],
              ['CU 0101689', 'Travis'],
              ['CU 0101690', 'Travis'],
              ['CU 0101691', 'Travis'],
              ['CU 0101692', 'Travis'],
              ['CU 0101693', 'Travis'],
              ['CU 0100851', 'Travis'],
              ['CU 0101694', 'Travis'],
              ['CU 0101695', 'Travis'],
              ['CU 0100706', 'Nate'],
              ['CU 0101696', 'Randy'],
              ['CU 0101697', 'Randy'],
              ['CU 0101698', 'Randy'],
              ['CU 0101699', 'Randy'],
              ['CU 0103555', 'Randy'],
              ['CU 0101701', 'Randy'],
              ['CU 0101702', 'Randy'],
              ['CU 0101703', 'Randy'],
              ['CU 0101705', 'Randy'],
              ['CU 0101706', 'Randy'],
              ['CU 0101707', 'Randy'],
              ['CU 0100587', 'Randy'],
              ['CU 0101708', 'Randy'],
              ['CU 0101711', 'Randy'],
              ['CU 0101712', 'Randy'],
              ['CU 0101714', 'Randy'],
              ['CU 0101246', 'Randy'],
              ['CU 0100645', 'Randy'],
              ['CU 0101338', 'Randy'],
              ['CU 0101715', 'Dan'],
              ['CU 0101716', 'Dan'],
              ['CU 0101718', 'Dan'],
              ['CU 0101717', 'Dan'],
              ['CU 0101720', 'Dan'],
              ['CU 0101721', 'Dan'],
              ['CU 0101722', 'Dan'],
              ['CU 0101215', 'Dan'],
              ['CU 0101723', 'Dan'],
              ['CU 0101724', 'Dan'],
              ['CU 0101725', 'Dan'],
              ['CU 0101726', 'Dan'],
              ['CU 0101727', 'Dan'],
              ['CU 0101728', 'Dan'],
              ['CU 0101729', 'Dan'],
              ['CU 0101731', 'Dan'],
              ['CU 0101760', 'Dan'],
              ['CU 0101761', 'Dan'],
              ['CU 0101762', 'Dan'],
              ['CU 0101763', 'Dan'],
              ['CU 0101764', 'Dan'],
              ['CU 0101766', 'Dan'],
              ['CU 0101767', 'Dan'],
              ['CU 0101768', 'Justin'],
              ['CU 0101770', 'Justin'],
              ['CU 0101772', 'Justin'],
              ['CU 0101773', 'Justin'],
              ['CU 0101774', 'Justin'],
              ['CU 0101775', 'Justin'],
              ['CU 0101776', 'Justin'],
              ['CU 0101777', 'Justin'],
              ['CU 0101778', 'Justin'],
              ['CU 0101780', 'Justin'],
              ['CU 0101781', 'Justin'],
              ['CU 0101782', 'Justin'],
              ['CU 0101783', 'Justin'],
              ['CU 0101784', 'Justin'],
              ['CU 0101785', 'Justin'],
              ['CU 0101786', 'Justin'],
              ['CU 0101787', 'Justin'],
              ['CU 0101788', 'Justin'],
              ['CU 0101789', 'Justin'],
              ['CU 0101790', 'Justin'],
              ['CU 0101791', 'Justin'],
              ['CU 0101793', 'Justin'],
              ['CU 0101794', 'Justin'],
              ['CU 0101795', 'Justin'],
              ['CU 0101796', 'Justin'],
              ['CU 0101797', 'Travis'],
              ['CU 0101798', 'Travis'],
              ['CU 0101800', 'Travis'],
              ['CU 0101801', 'Travis'],
              ['CU 0101802', 'Travis'],
              ['CU 0101803', 'Travis'],
              ['CU 0101804', 'Travis'],
              ['CU 0101806', 'Travis'],
              ['CU 0101807', 'Travis'],
              ['CU 0101808', 'Travis'],
              ['CU 0101810', 'Travis'],
              ['CU 0101143', 'Travis'],
              ['CU 0101811', 'Travis'] 
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
        # accounts.each { |account| self.create_queue(account)  } 
        accounts.each { |account| self.create_queue(account) unless account.ax_account_number == 'CU 0101652'  } 
        

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
      subject = "Your RED ONE is ready to ship"
      super({:subject => subject, :from => staff_name_with_email_address})
    end
  end
