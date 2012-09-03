class RebuildReadAxTables < ActiveRecord::Migration
  def self.up
    create_table :ax_accounts, :force => true do |t|
      t.column :ax_account_number,              :string, :limit => 20
      t.column :account_balance,                :float,  :default => 0.0
      t.column :discounts,                      :float,  :default => 0.0
      t.column :currency,                       :string, :limit => 20
      t.column :cust_first_name,                :string
      t.column :cust_last_name,                 :string
      t.column :email,                          :string
      t.column :cust_group,                     :string, :limit => 20
      t.column :language_id,                    :string, :limit => 20
      t.column :phone,                          :string
      t.column :address,                        :string
      t.column :city,                           :string
      t.column :country_region_id,              :string
      t.column :state,                          :string, :limit => 20
      t.column :street,                         :string
      t.column :contact_person_name,            :string
      t.column :contact_person_select_address,  :string
      t.column :created_date,                   :date
      t.column :modified_date,                  :date
      t.column :status,                         :string, :limit => 20
      t.column :updated_at,                     :datetime
    end

    add_index :ax_accounts, :ax_account_number
    
    create_table :ax_account_addresses, :force => true do |t|
      t.column :ax_account_id,     :integer
      t.column :ax_account_number, :string
      t.column :address_type,      :string
      t.column :address,           :string
      t.column :city,              :string
      t.column :country_region_id, :string, :limit => 20
      t.column :state,             :string, :limit => 20
      t.column :street,            :string      
    end
   
    create_table :ax_orders, :force => true do |t|
      t.column :ax_order_number,            :string, :limit => 20
      t.column :ax_account_id,              :integer
      t.column :ax_account_number,          :string, :limit => 20
      t.column :delivery_city,              :string
      t.column :delivery_country_region_id, :string, :limit => 20
      t.column :delivery_country,           :string
      t.column :delivery_date,              :date
      t.column :delivery_state,             :string
      t.column :delivery_street,            :string
      t.column :delivery_zip_code,          :string
      t.column :purch_order_form_num,       :string
      t.column :sales_tax,                  :float
      t.column :shipping_charges,           :float
      t.column :discounts,                  :float
      t.column :created_date,               :date
      t.column :modified_date,              :date
      t.column :sales_status,               :string
      t.column :status,                     :string, :limit => 20
      t.column :updated_at,                 :datetime
    end

    add_index :ax_orders, :ax_order_number
    add_index :ax_orders, :ax_account_id

    create_table :ax_order_line_items, :force => true do |t|
      t.column :ax_order_number,       :string, :limit => 20
      t.column :ax_order_id,           :integer
      t.column :confirmed_lv,          :date
      t.column :delivered_in_total,    :integer
      t.column :invoiced_in_total,     :integer
      t.column :item_id,               :string, :limit => 20
      t.column :remain_sales_physical, :integer
      t.column :sales_item_reservation_number, :string
      t.column :sales_qty,             :integer
      t.column :sales_unit,            :string, :limit => 20
      t.column :updated_at,            :datetime
    end

    add_index :ax_order_line_items, :ax_order_id
    add_index :ax_order_line_items, :item_id
    add_index :ax_order_line_items, :remain_sales_physical
    add_index :ax_order_line_items, :sales_item_reservation_number
  end

  def self.down
    drop_table :ax_account_addresses
  end
end