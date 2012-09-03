class AddMailTasks < ActiveRecord::Migration
  def self.up
    # Task
    create_table "tasks" do |t|
      t.column "name", :string, :null => false
      t.column "description", :text
      t.column "subject", :string
      t.column "from", :string
      t.column "variables", :text
      t.column "template_body", :text
      t.column "template_id", :integer
      t.column "mails_count", :integer, :null => false, :default => 0
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
    add_index "tasks", "created_at"
    
    # Mail
    create_table "mails" do |t|
      t.column "task_id", :integer
      t.column "email", :string, :null => false
      # t.column "first_name", :string
      # t.column "last_name", :string
      t.column "name", :string, :limit => 128
      t.column "company_name", :string
      t.column "account_num", :string, :limit => 16
      t.column "sales_id", :string, :limit => 16
      t.column "red_one_serial_number", :string, :limit => 32
      t.column "token", :string, :limit => 128
      t.column "content", :text, :null => false
      t.column "rep_email", :string
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "read_at", :datetime
      t.column "sent_at", :datetime
    end
    [:task_id, :email, :account_num, :sales_id, :red_one_serial_number, :token, :created_at].each do |field|
      add_index :mails, field
    end
    
    # Template
    create_table "templates" do |t|
      t.column "name", :string, :null => false
      t.column "description", :text
      t.column "subject", :string, :null => false
      t.column "from", :string, :null => false
      t.column "body", :text, :null => false
      t.column "variables", :text
      t.column "created_at", :datetime
    end
    [:name, :created_at].each do |field|
      add_index :templates, field
    end
    
    # Delivery Log
    create_table "delivery_logs" do |t|
      t.column "mail_id", :integer, :null => false
      t.column "content", :text
      t.column "successful", :boolean, :null => false, :default => false
      t.column "description", :text
      t.column "created_at", :datetime
      t.column "bounced_at", :datetime
    end
    [:mail_id, :successful, :created_at].each do |field|
      add_index :delivery_logs, field
    end
  end
  
  def self.down
    [:mails, :tasks, :delviery_logs, :templates].each do |t|
      drop_table t
    end
  end
end