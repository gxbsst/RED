class MailTaskFebHelloRedoneOwnerQueue < ActiveRecord::Base
      
  include MailTask::General
  
  belongs_to :mail_task
  
  class << self
    def init_queues
      begin_time = Time.now
      
      # cleanup exists queues
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
      AxAccount.find(:all, :conditions => ['red_one_shipped = ?', 'Yes']).each do |account|
        if account.email_address.blank?
          open("#{RAILS_ROOT}/log/invalid_order_account.log", "a+") do |file|
            file << "#{account.ax_account_number}: email address is empyt\n"
          end
          next
        end
        self.create_queue(account)
      end
      
      puts %(Amount: #{self.count} records in Mail Queue.)
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
        :sid                           => UUID.random_create.to_s.gsub(/-/,'')
      )
    end
  end
  
  def send_mail
    options = {
      :subject => "Hello RED Owners",
      :from    => "Ted <ted@red.com>"
    }
    super(options)
  end
end
