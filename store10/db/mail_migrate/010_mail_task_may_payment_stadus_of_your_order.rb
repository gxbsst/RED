class MailTaskMayPaymentStadusOfYourOrder < ActiveRecord::Migration
  def self.up
    create_table "mail_task_may_payment_stadus_of_your_orders", :force => true do |t|
      t.column "ax_order_number", :string
      t.column "order_date", :string
      t.column "ax_account_number", :string
      t.column "email_address", :string
      t.column "camerma_number", :string
      t.column "full_name", :string
      t.column "prepayments_due", :string
      t.column "prepayments_received", :string
      t.column "prepayments_needed", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
   
  end

  
  def self.down
    drop_table :mail_task_may_payment_stadus_of_your_orders
  end
end