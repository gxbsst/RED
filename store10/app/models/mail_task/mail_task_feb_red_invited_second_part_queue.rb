class MailTaskFebRedInvitedSecondPartQueue < ActiveRecord::Base

  include MailTask::General
  
  belongs_to :mail_task
  
  Delivery_range_begin = 301
  Delivery_range_end   = 500
  
  class << self
    def init_queues
      begin_time = Time.now
      
      # cleanup exists queues
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
      
      # get all line item which include redone and serial number in range.
      line_items = AxOrderLineItem.find(:all, :conditions => [
          'item_id = ? and sales_item_reservation_number in (?)',
          Product::REDONE_ERP_PRODUCT_ITEM,
          (Delivery_range_begin..Delivery_range_end)
        ])
      lost = (Delivery_range_begin..Delivery_range_end).map{|i|i.to_s} - line_items.map(&:sales_item_reservation_number)
      
      line_items.select do |item|
        open("#{RAILS_ROOT}/log/invalid_order_account.log", "a+") do |file|
          file << "#{item.ax_account_number}: email address is empyt\n"
        end if item.email_address.blank?
        
        !item.ax_order.ax_account.blank? && !item.email_address.blank?
      end.group_by { |item| item.ax_order.ax_account }.map{|account,items| [account, items]}.sort_by {|i| i[0].ax_account_number.gsub(/\D/,'').to_i}.each do |i|
        self.create_queue(i[0], i[1])
      end
      
      puts %(Redone serial number range: ##{Delivery_range_begin} to ##{Delivery_range_end}.)
      puts %(Lost Redone serial number in range: [#{lost.join(",")}].)
      puts %(Amount: #{line_items.size} line_items include redone body.)
      puts %(Amount: #{self.count} records in Mail Queue.)
      puts %(Use #{Time.now - begin_time} seconds.)
    end
    
    def create_queue(account, items)
      self.create(
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
        :sid                           => UUID.random_create.to_s.gsub(/-/,''),
        :serial_numbers                => items.map(&:sales_item_reservation_number).join(",")
      )
    end
  end
  
  def send_mail
    options = {
      :subject => "RED DAY Invitation",
      :from    => "RED <orders@red.com>"
    }
    super(options)
  end
end
