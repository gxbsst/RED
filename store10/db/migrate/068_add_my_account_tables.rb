class AddMyAccountTables < ActiveRecord::Migration
  def self.up
    create_table :erp_customers do |t|
      t.column :account_num, :string, :limit => 32
      t.column :first_name, :string, :limit => 64
      t.column :last_name, :string, :limit => 32
      t.column :group, :string, :limit => 16, :null => false, :default => 'INT'
      t.column :discounts, "decimal(18, 2)"
      t.column :email, :string
      t.column :language_id, :string, :limit => 16, :null => false, :default => 'en_us'
      t.column :erp_modstamp, :datetime
      t.column :phone, :string, :limit => 64
      t.column :account_balance, "decimal(10, 2)"
      t.column :currency, :string, :limit => 16, :null => false, :default => "USD"
      t.column :red_one_shipped, :boolean, :null => false, :default => 0
      t.column :assigned_to, :string, :limit => 128
      t.column :ship_to_id, :int
      t.column :bill_to_id, :int
      t.column :name, :string, :limit => 128
      t.column :delivery_mode, :string
      t.column :synchronized, :boolean, :null => false, :default => 1
      t.column :updated_at, :datetime
      t.column :created_date, :datetime
    end
    add_index "erp_customers", :id
    add_index "erp_customers", :account_num
    add_index "erp_customers", :synchronized
    
    create_table "erp_contact_people" do |t|
      t.column :erp_customer_id, :int, :null => false
      t.column :first_name, :string, :limit => 64
      t.column :last_name, :string, :limit => 64
      t.column :name, :string, :limit => 128
      t.column :email, :string
      t.column :newly_created, :boolean, :null => false, :default => true
    end
    add_index "erp_contact_people", :erp_customer_id
    
    create_table "erp_addresses" do |t|
      t.column :city, :string, :limit => 64
      t.column :country_region_id, :string, :limit => 4
      t.column :state, :string, :limit => 64
      t.column :street, :string
      t.column :zip_code, :string, :limit => 16
      t.column :address, :text
      t.column :county, :string, :limit => 64
      t.column :country, :string
      t.column :record_id, :string, :null => false, :default => 0
      t.column :address_type, :string, :limit => 32
      t.column :hash, :string, :limit => 128
      t.column :parent_id, :int
      t.column :type, :string, :limit => 32
      t.column :name, :string, :limit => 128
    end
    add_index "erp_addresses", :hash
    add_index "erp_addresses", :type
    add_index "erp_addresses", :parent_id
    
    create_table "erp_sales_orders" do |t|
      t.column :sales_id, :string, :limit => 32
      t.column :erp_customer_id, :int, :null => false
      t.column :delivery_date, :date
      t.column :modified_date, :date
      t.column :purch_order_form_num, :string, :limit => 64
      t.column :sales_status, :string, :limit => 32
      t.column :shipping_charges, "decimal(10, 2)"
      t.column :delivery_mode_id, :string, :limit => 16
      t.column :ax_shipping_charges, "decimal(10, 2)"
      t.column :ax_delivery_mode_id, :string, :limit => 16
      t.column :completed, :boolean, :null => false, :default => 0
      t.column :document_status, :string, :limit => 32
      t.column :erp_modstamp, :datetime
      t.column :sales_tax, "decimal(10, 2)"
      t.column :synchronized, :boolean, :null => false, :default => 1
      t.column :updated_at, :datetime
      t.column :deleted, :boolean, :null => false, :default => false
    end
    add_index "erp_sales_orders", :erp_customer_id
    add_index "erp_sales_orders", :completed
    add_index "erp_sales_orders", :synchronized
    
    create_table "erp_sales_lines" do |t|
      t.column :erp_sales_order_id, :int, :null => false
      t.column :confirmed_dlv, :string, :limit => 64
      t.column :item_id, :string, :limit => 32, :null => false
      t.column :remain_sales_physical, "decimal(10, 0)", :null => false, :default => 0
      t.column :sales_item_revervation_number, :string, :limit => 128
      t.column :sales_qty, "decimal(10, 0)"
      t.column :sales_price, "decimal(12, 2)"
      t.column :line_amount, "decimal(18, 2)"
      t.column :line_percent, :string
      t.column :sales_unit, :string, :limit => 4, :null => false, :default => "Ea"
      t.column :delivered_in_total, "decimal(10, 2)"
      t.column :invoiced_in_total, "decimal(10, 2)"
      t.column :invent_trans_id, :string, :limit => 32
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
      t.column :completed, :boolean, :null => false, :default => 0
    end
    add_index "erp_sales_lines", :erp_sales_order_id
    add_index "erp_sales_lines", :item_id
    
    create_table "erp_logs" do |t|
      t.column :code, :int
      t.column :response, :longtext
      t.column :message, :text
      t.column :uuid, :string, :limit => 50
      t.column :post_body, :longtext
      t.column :service_url, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :update_complete, :boolean
    end
    add_index "erp_logs", :uuid
  end
  
  def self.down
    ["erp_customers", "erp_addresses", "erp_contact_people", "erp_sales_orders", "erp_sales_lines", "erp_logs"].each { |table| drop_table table }
  end
end
