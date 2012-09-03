module ERP
  class SerialNumber < ActiveRecord::Base
    
    # Find out existing serial number with given account number and serial number. Nothing will be
    # changed if exists, or create a new record for it and then send notification to this customer
    # else.
    # 
    # Example:
    #   ERP::SerialNumber.find_or_create(
    #     :account_num => "CU 0000001",
    #     :sales_id => "SO 0100001",
    #     :item_id => "101001",
    #     :serial => "1234"
    #   )
    def self.find_or_create( attrs )
      return self.find_by_sales_id_and_item_id_and_serial(
        attrs[:sales_id],
        attrs[:item_id],
        attrs[:serial]
      ) || self.create( attrs )
    end
    
    # Find out all newly created serials and try to deliver notification mails to customer for these
    # all immediately. Mails will be generated by RED Mail Blaster under task named "Serial Number
    # Notification"
    # 
    # Requires:
    # 1. Existing mail tasks named "Serial Number Notification"
    # 2. Existing mail template if necessary
    def self.deliver_notifications_to( account_num )
      task = MailTasks::Task.find_by_name('Serial Number Notification')
      serials = self.find(
        :all,
        :conditions => ['notification_sent = false and account_num = ?', account_num]
      )
      return false if serials.empty? # do nothing if no serials for this account

      recipients = StoreUser.find_all_by_erp_account_number(account_num)
      mails = task.generate_mails( recipients, true, mail_options( serials.map(&:serial) ) )
      
      mails.each { |mail| mail.deliver(mail_options) }
      self.update_all(
        "notification_sent = true, notification_sent_at = '#{Time.now.to_s(:db)}'",
        "notification_sent = false AND account_num = '#{account_num}'"
      )
    end
    
    # Callback method(s) fired while saving.
    def before_save
      convert_serial_number
    end
    
    private
    
    # Options for generating mail's layout. Refer to Admin::MailsController#mail_layout_options for
    # basic values. Additional, providing "serial" (string / number) as parameter will also be
    # available while editing mail template.
    def self.mail_options( serials=[] )
      return {
        :post_back_url => "http://www.red.com/email/red_logo", :base => "http://www.red.com"
      }.merge( :serials => serials.join(", ") )
    end
    
    # Convert item's serial number into number.
    def convert_serial_number
      self.serial_number = self.serial.to_i
    end
    
  end
end