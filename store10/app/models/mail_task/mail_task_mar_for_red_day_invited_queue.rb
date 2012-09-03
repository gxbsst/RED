class MailTaskMarForRedDayInvitedQueue < ActiveRecord::Base

  include MailTask::General
  
  belongs_to :mail_task
  
  Delivery_range_begin = 751
  Delivery_range_end   = 1250
  
  class << self
    def init_queues
      begin_time = Time.now
      
      # cleanup exists queues
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
      
      # get all line item which include redone and serial number in range.
      line_items = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number in (?)', Product::REDONE_ERP_PRODUCT_ITEM, (Delivery_range_begin..Delivery_range_end)])
      lost = (Delivery_range_begin..Delivery_range_end).map{|i|i.to_s} - line_items.map(&:sales_item_reservation_number)
      
      line_items.map(&:ax_order).uniq.compact.select{ |order| order.status != 'ERROR' }.select do |order|
        if message = order.prepare_delivery_validation
          open("#{RAILS_ROOT}/log/invalid_orders.log", "a+") { |file| file << "#{message}\n" }
          false
        else
          true
        end
      end.map(&:ax_account).uniq.each do |account|
        create_queue(account)
      end
        
      puts %(Redone serial number range: ##{Delivery_range_begin} to ##{Delivery_range_end}.)
      puts %(Lost Redone serial number in range: [#{lost.join(",")}].)
      puts %(Amount: #{line_items.size} line_items include redone body.)
      puts %(Amount: #{self.count} records in Mail Queue.)
      puts %(Use #{Time.now - begin_time} seconds.)
    end
    
    def create_queue(account)
      self.create(
        :ax_account_number             => account.ax_account_number,
        :email_address                 => account.email_address,
        :first_name                    => account.first_name,
        :last_name                     => account.last_name,
        :sid                           => sid_generator
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
  