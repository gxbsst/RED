class RedoneSerialNumber < ActiveRecord::Base
  belongs_to :ax_account
  belongs_to :ax_order
  
  # Class method begin here.
  class << self
    # sync with result of read ax and add new serial number to mail queues.
    def sync
      update_records
      add_to_mail_queues
    end
    
    # update records for new
    def update_records
      # Get all line items include redone body and it's serial number.
      line_items = AxOrderLineItem.find(:all, :conditions => ['item_id = ? and sales_item_reservation_number <> ?', Product::REDONE_ERP_PRODUCT_ITEM, ''], :include => :ax_order)
      
      # Get all serial numbers from ax order line items.
      serial_numbers = line_items.map(&:serial_number).sort_by { |i| i.to_i }
      
      # Calc all new serial numbers.
      new_serial_numbers = serial_numbers - self.find(:all).map(&:serial_number)
      
      # Add new serial numbers to database.
      new_serial_numbers.each do |serial_number|
        line_item = line_items.find {|i| i.serial_number == serial_number}
        self.create(
          :ax_account_number    => line_item.ax_account_number,
          :ax_account_id        => line_item.ax_account_id,
          :ax_order_number      => line_item.ax_order_number,
          :ax_order_id          => line_item.ax_order_id,
          :email_address        => line_item.email_address,
          :first_name           => line_item.first_name,
          :last_name            => line_item.last_name,
          :serial_number        => line_item.serial_number,
          :purch_order_form_num => line_item.purch_order_form_num
        )
      end
      
      # Update exist but not sent records data up to date.
      self.find(:all, :conditions => ['sent_mail = ?', false]).each do |item|
        if line_item = line_items.find {|i| i.serial_number == item.serial_number}
          item.update_attributes(
            :ax_account_number     => line_item.ax_account_number,
            :ax_account_id         => line_item.ax_account_id,
            :ax_order_number       => line_item.ax_order_number,
            :ax_order_id           => line_item.ax_order_id,
            :email_address         => line_item.email_address,
            :first_name            => line_item.first_name,
            :last_name             => line_item.last_name,
            :serial_number         => line_item.serial_number,
            :purch_order_form_num  => line_item.purch_order_form_num
          ) unless compare_equal?(item, line_item)
        end
      end
    end
    
    # compare all necessary attributes if changed.
    def compare_equal?(item, line_item)
      ![
        :ax_account_number,
        :ax_account_id,
        :ax_order_number,
        :ax_order_id,
        :email_address,
        :first_name,
        :last_name,
        :serial_number,
        :purch_order_form_num
      ].detect { |attr| item.send(attr) != line_item.send(attr) }
    end
    
    # add new records to notify mail queues.
    def add_to_mail_queues
      # get all valid item which has not yet add to mail queues.
      serial_numbers = self.find(:all, :conditions => ['sent_mail = ?', false]).select{ |record| record.validate_for_sent? }
      
      # group items by ax_account and combine it's serial/order number pre order and add to mail queues.
      serial_numbers.group_by{ |i| i.ax_order }.each do |ax_order, items|
        MailTaskRedoneSerialNumberNotifyQueue.create(
          :ax_account_number    => ax_order.ax_account_number,
          :ax_order_number      => ax_order.ax_order_number,
          :email_address        => ax_order.email_address,
          :first_name           => ax_order.first_name,
          :last_name            => ax_order.last_name,
          :serial_number        => items.map(&:serial_number).map{|n|"##{n}"}.join(', '),
          :purch_order_form_num => ax_order.purch_order_form_num,
          :sid                  => UUID.random_create.to_s.gsub(/-/,'')
        )
        items.each { |item| item.update_attribute(:sent_mail, true) }
      end
    end
  end
  
  # Instance method begin here
  def validate_for_sent?
    [
      :ax_account_number,
      :ax_account_id,
      :ax_order_number,
      :ax_order_id,
      :email_address,
      #:first_name,
      #:last_name,
      :serial_number
    ].detect { |attr| self.send(attr).blank? }.nil?
  end
end
