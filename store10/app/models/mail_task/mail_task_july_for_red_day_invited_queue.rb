class MailTaskJulyForRedDayInvitedQueue < ActiveRecord::Base

  include MailTask::General

   belongs_to :mail_task
  
  Delivery_range_begin = 1751
  Delivery_range_end   = 2250
  
  class << self
    def init_queues
      begin_time = Time.now
      
      # cleanup exists queues
        [
          "TRUNCATE #{table_name}"
          ].each do |statement|
            connection.execute(statement)
          end   
            # get all redone that serial number in the range.
            line_items = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?) ', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end)])
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
            # puts %(Missing Staff assign to: #{missing_assign_to_list.join(", ")})
            puts %(Use #{Time.now - begin_time} seconds.)
          end
    
    
    def create_queue(account)
      self.create(
        :ax_account_number             => account.ax_account_number,
        :account_balance               => account.account_balance,
        :discounts                     => account.discounts,
        :email_address                 => account.email_address,
        :first_name                    => account.first_name,
        :last_name                     => account.last_name,
        :phone                         => account.phone,
        :contact_person_name           => account.contact_person_name,
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
    end
  end
  
  def send_mail
    options = {
      :subject => "RED DAY Invitation",
      :from    => "RED <redorders@red.com>"
    }
    super(options)
  end
end
