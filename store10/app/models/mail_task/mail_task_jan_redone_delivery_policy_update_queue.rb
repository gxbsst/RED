class MailTaskJanRedoneDeliveryPolicyUpdateQueue < ActiveRecord::Base
  
  include MailTask::General
  
  belongs_to :mail_task
  
  Delivery_range_begin = 6
  Delivery_range_end   = 500
  
  class << self
    def init_queues
      # cleanup exists queues
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")
      
      MailTaskJanRedoneDeliveryPolicySixToFiveHundredQueue.find(:all).each do |queue|
        self.create_queue(queue)
      end
    end
    
    def create_queue(queue)
      self.create(
        :ax_account_number             => queue.ax_account_number,
        :account_balance               => queue.account_balance,
        :discounts                     => queue.discounts,
        :email_address                 => queue.email_address,
        :first_name                    => queue.first_name,
        :last_name                     => queue.last_name,
        :phone                         => queue.phone,
        :contact_person_name           => queue.contact_person_name,
        :contact_person_select_address => queue.contact_person_select_address,
        :address                       => queue.address,
        :invoice_address               => queue.invoice_address,
        :invoice_city                  => queue.invoice_city,
        :invoice_country_region_id     => queue.invoice_country_region_id,
        :invoice_state                 => queue.invoice_state,
        :invoice_street                => queue.invoice_street,
        :delivery_address              => queue.delivery_address,
        :delivery_city                 => queue.delivery_city,
        :delivery_country_region_id    => queue.delivery_country_region_id,
        :delivery_state                => queue.delivery_state,
        :delivery_street               => queue.delivery_street,
        :sid                           => UUID.random_create.to_s.gsub(/-/,''),
        :serial_numbers                => queue.serial_numbers
      )
    end
  end
  
  def send_mail
    options = {
      :subject => "UPDATED: Delivery Policy",
      :from    => "RED <sales@red.com>"
    }
    super(options)
  end
end
