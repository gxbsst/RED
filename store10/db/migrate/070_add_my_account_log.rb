class AddMyAccountLog < ActiveRecord::Migration
  def self.up
    create_table 'my_account_logs' do |t|
      t.column 'email', :string
      t.column 'account_num', :string # (AX/ERP Account Number)
      t.column 'sales_order_num', :string # (AX/ERP Account Number)
      t.column 'email', :string # (Actual Email Address, not an ID)
      t.column 'class_name', :string  # (erp_sales_orders, erp_sales_lines, erp_customers, erp_addresses, erp_contacts)
      t.column 'record_id', :integer # (pointer to record primary key from table in the table_name column)
      t.column 'action', :string # (rails action name)
      t.column 'description', :string # (item XXX quantity 5 => 0)
      t.column 'remote_ip', :string # (Remote User's IP Address)
      t.column 'remote_location', :string # (Database Lookup Value Based on User's IP Address)
      t.column 'path', :string # (request.path sent from the browser)
      t.column 'user_agent', :string # (Complete Web Browser "User Agent" String)
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
    end 
  end

  def self.down
    drop_table :my_account_logs
  end
end
