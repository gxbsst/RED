class MailTaskJulyNearlyReadyToShipQueueLineItem < ActiveRecord::Base
  include MailTask::General
  belongs_to :mail_task_july_nearly_ready_to_ship_queue
end

class MailTaskJulyNearlyReadyToShipQueue < ActiveRecord::Base
  belongs_to :mail_task
  include MailTask::General
  has_many :mail_task_july_nearly_ready_to_ship_queue_line_items, :dependent => :destroy
    Delivery_range_begin = 2201
    Delivery_range_end   = 2400

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
              ['CU 0101811', 'Randy'],
              ['CU 0101812', 'Randy'],
              ['CU 0101814', 'Randy'],
              ['CU 0100345', 'Randy'],
              ['CU 0101815', 'Randy'],
              ['CU 0101816', 'Randy'],
              ['CU 0101817', 'Randy'],
              ['CU 0101818', 'Randy'],
              ['CU 0101819', 'Randy'],
              ['CU 0101821', 'Randy'],
              ['CU 0101822', 'Randy'],
              ['CU 0100442', 'Randy'],
              ['CU 0101823', 'Randy'],
              ['CU 0101824', 'Randy'],
              ['CU 0101825', 'Randy'],
              ['CU 0100621', 'Randy'],
              ['CU 0100185', 'Randy'],
              ['CU 0101826', 'Randy'],
              ['CU 0101827', 'Randy'],
              ['CU 0101828', 'Justin'],
              ['CU 0101829', 'Justin'],
              ['CU 0101830', 'Justin'],
              ['CU 0101831', 'Justin'],
              ['CU 0101832', 'Justin'],
              ['CU 0101839', 'Justin'],
              ['CU 0101840', 'Justin'],
              ['CU 0101841', 'Justin'],
              ['CU 0101842', 'Justin'],
              ['CU 0101142', 'Justin'],
              ['CU 0101573', 'Justin'],
              ['CU 0101045', 'Justin'],
              ['CU 0101844', 'Justin'],
              ['CU 0101845', 'Justin'],
              ['CU 0101846', 'Justin'],
              ['CU 0101849', 'Justin'],
              ['CU 0101848', 'Justin'],
              ['CU 0101850', 'Justin'],
              ['CU 0101852', 'Justin'],
              ['CU 0101853', 'Justin'],
              ['CU 0101855', 'Justin'],
              ['CU 0101854', 'Justin'],
              ['CU 0101856', 'Justin'],
              ['CU 0101858', 'Chad'],
              ['CU 0101859', 'Chad'],
              ['CU 0101860', 'Chad'],
              ['CU 0101862', 'Chad'],
              ['CU 0101863', 'Chad'],
              ['CU 0101864', 'Chad'],
              ['CU 0100254', 'Chad'],
              ['CU 0101865', 'Chad'],
              ['CU 0101560', 'Chad'],
              ['CU 0101866', 'Chad'],
              ['CU 0101867', 'Chad'],
              ['CU 0100989', 'Chad'],
              ['CU 0101868', 'Chad'],
              ['CU 0101870', 'Chad'],
              ['CU 0100841', 'Chad'],
              ['CU 0101871', 'Chad'],
              ['CU 0101873', 'Chad'],
              ['CU 0101874', 'Chad'],
              ['CU 0101875', 'Polo'],
              ['CU 0100210', 'Polo'],
              ['CU 0101876', 'Polo'],
              ['CU 0101879', 'Polo'],
              ['CU 0101880', 'Polo'],
              ['CU 0101881', 'Polo'],
              ['CU 0101885', 'Polo'],
              ['CU 0101886', 'Polo'],
              ['CU 0101887', 'Polo'],
              ['CU 0101888', 'Polo'],
              ['CU 0101889', 'Polo'],
              ['CU 0101890', 'Polo'],
              ['CU 0101891', 'Polo'],
              ['CU 0101892', 'Polo'],
              ['CU 0101893', 'Polo'],
              ['CU 0101894', 'Polo'],
              ['CU 0101895', 'Polo'],
              ['CU 0101897', 'Polo'],
              ['CU 0101898', 'Polo'],
              ['CU 0101896', 'Polo'],
              ['CU 0100927', 'Travis'],
              ['CU 0100802', 'Travis'],
              ['CU 0101721', 'Travis'],
              ['CU 0101903', 'Travis'],
              ['CU 0101904', 'Travis'],
              ['CU 0101905', 'Travis'],
              ['CU 0101900', 'Travis'],
              ['CU 0101901', 'Travis'],
              ['CU 0101902', 'Travis'],
              ['CU 0100218', 'Travis'],
              ['CU 0101906', 'Travis'],
              ['CU 0101908', 'Travis'],
              ['CU 0101909', 'Travis'],
              ['CU 0101907', 'Travis'],
              ['CU 0101911', 'Travis'],
              ['CU 0101910', 'Travis'],
              ['CU 0101912', 'Travis'],
              ['CU 0101916', 'BrianB'],
              ['CU 0101917', 'BrianB'],
              ['CU 0101918', 'BrianB'],
              ['CU 0100316', 'BrianB'],
              ['CU 0101725', 'BrianB'],
              ['CU 0101920', 'BrianB'],
              ['CU 0101922', 'BrianB'],
              ['CU 0101921', 'BrianB'],
              ['CU 0101923', 'BrianB'],
              ['CU 0101924', 'BrianB'],
              ['CU 0101925', 'BrianB'],
              ['CU 0101927', 'BrianB'],
              ['CU 0101678', 'BrianB'],
              ['CU 0101929', 'BrianB'],
              ['CU 0101931', 'BrianB'],
              ['CU 0101930', 'BrianB'],
              ['CU 0101932', 'BrianB'],
              ['CU 0101933', 'BrianB'],
              ['CU 0101934', 'BrianB'],
              ['CU 0101935', 'BrianB'],
              ['CU 0101936', 'BrianB'],
              ['CU 0101937', 'BrianB'],
              ['CU 0100864', 'BrianB'],
              ['CU 0100513', 'BrianB'],
              ['CU 0101938', 'Restivo'],
              ['CU 0101939', 'Restivo'],
              ['CU 0101940', 'Restivo'],
              ['CU 0101941', 'Restivo'],
              ['CU 0100587', 'Restivo'],
              ['CU 0101942', 'Restivo'],
              ['CU 0101943', 'Restivo'],
              ['CU 0101944', 'Restivo'],
              ['CU 0101946', 'Restivo'],
              ['CU 0101947', 'Restivo'],
              ['CU 0101948', 'Restivo'],
              ['CU 0101949', 'Restivo'],
              ['CU 0101480', 'Restivo'],
              ['CU 0101951', 'Restivo'],
              ['CU 0101338', 'Restivo'],
              ['CU 0101952', 'Restivo'],
              ['CU 0101953', 'Restivo'],
              ['CU 0101954', 'Restivo'],
              ['CU 0101955', 'Restivo'],
              ['CU 0101956', 'Restivo'],
              ['CU 0101957', 'Dan'],
              ['CU 0101958', 'Dan'],
              ['CU 0101959', 'Dan'],
              ['CU 0101960', 'Dan'],
              ['CU 0101961', 'Dan'],
              ['CU 0101962', 'Dan'],
              ['CU 0101963', 'Dan'],
              ['CU 0100844', 'Dan'],
              ['CU 0101485', 'Dan'],
              ['CU 0101964', 'Dan'],
              ['CU 0101965', 'Dan'],
              ['CU 0101966', 'Dan'],
              ['CU 0101967', 'Dan'],
              ['CU 0101968', 'Dan']
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
        accounts.each { |account| self.create_queue(account) unless (account.ax_account_number == 'CU 0101847' || account.ax_account_number == 'CU 0101928' || account.ax_account_number == 'CU 0101950' || account.ax_account_number == 'CU 0101926' || account.ax_account_number == 'CU 0101914' || account.ax_account_number == 'CU 0101915') } 
        

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
