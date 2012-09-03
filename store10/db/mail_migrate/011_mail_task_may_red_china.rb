class MailTaskMayRedChina < ActiveRecord::Migration
  def self.up
    create_table "mail_task_may_red_chinas", :force => true do |t|
      t.column "mail_task_id", :integer
      t.column "ax_account_number", :string
      t.column "email_address", :string
      t.column "full_name", :string
      t.column "en_full_name", :string
      t.column "city", :string
      t.column "complete", :boolean, :default => false
      t.column "sid", :string
      t.column "readed_at", :datetime
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  end
  
  def self.down
    drop_table :mail_task_may_red_chinas
  end
end