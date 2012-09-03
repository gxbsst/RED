class MailTaskJulyRedOneDeliveryLastCallQueues < ActiveRecord::Migration
  def self.up
      create_table "mail_task_july_red_one_delivery_last_call_queues", :force => true do |t|
         t.column "mail_task_id", :integer
         t.column "ax_account_number", :string
         # t.column "account_balance", :float, :default => 0.0
         # t.column "discounts", :float, :default => 0.0
         t.column "email_address", :string
         t.column "first_name", :string
         t.column "last_name", :string
         t.column "phone", :string
         t.column "contact_person_name", :string
         t.column "contact_person_select_address", :string
         t.column "address", :string
         t.column "invoice_address", :string
         t.column "invoice_city", :string
         t.column "invoice_country_region_id", :string
         t.column "invoice_state", :string
         t.column "invoice_street", :string
         t.column "delivery_address", :string
         t.column "delivery_city", :string
         t.column "delivery_country_region_id", :string
         t.column "delivery_state", :string
         t.column "delivery_street", :string
         t.column "assign_to", :string
         t.column "complete", :boolean, :default => false
         t.column "sid", :string
         t.column "readed_at", :datetime
         t.column "created_at", :datetime
         t.column "updated_at", :datetime
         t.column "serial_numbers", :string
       end
  end

  def self.down
    drop_table :mail_task_july_red_one_delivery_last_call_queues
  end
end