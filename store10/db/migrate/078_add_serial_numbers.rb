# Add Serial Numbers table for holding records with serial numbers detected in sales orders.
# In additional, also saved with the notification status for each record that marks whether mail
# has been sent to it's purchaser or not.
class AddSerialNumbers < ActiveRecord::Migration
  def self.up
    create_table :serial_numbers do |t|
      t.column "account_num", :string, :limit => 20, :null => false, :default => ""
      t.column "sales_id", :string, :limit => 20, :null => false, :default => ""
      t.column "item_id", :string, :limit => 10, :null => false, :default => ""
      t.column "serial", :string, :limit =>10, :null => false, :default => ""
      t.column "serial_number", :int, :null => false, :default => 0
      t.column "status", :string, :limit => 10, :null => false, :default => "None"
      t.column "notification_sent", :boolean, :null =>false, :default => false
      t.column "notification_sent_at", :datetime
      t.column "created_at", :datetime
    end
    
    [:account_num, :sales_id, :serial_number, :status].each do |field|
      add_index :serial_numbers, field
    end
  end
  
  def self.down
    drop_table :serial_numbers
  end
end