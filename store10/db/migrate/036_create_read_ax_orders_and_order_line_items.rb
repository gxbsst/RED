class CreateReadAxOrdersAndOrderLineItems < ActiveRecord::Migration
  def self.up
    
    create_table :ax_accounts do |t|
      t.column :ax_account_number,    :string, :limit => 20
      t.column :address,              :string
      t.column :currency,             :string, :limit => 20
      t.column :cust_group,           :string, :limit => 20
      t.column :cust_fist_name,       :string
      t.column :cust_last_name,       :string
      t.column :cust_email,           :string
      t.column :cust_language_id,     :string, :limit => 20
      t.column :contact_person_name,  :string
      t.column :contact_person_select_address, :string
      t.column :address_1_address,    :string
      t.column :status,               :string, :limit => 20
      t.column :updated_at,           :datetime
    end

    add_index :ax_accounts, :ax_account_number

    create_table :ax_orders do |t|
      t.column :ax_order_number,           :string, :limit => 20
      t.column :ax_account_id,             :integer
      t.column :ax_account_number,         :string, :limit => 20
      t.column :deliver_city,              :string
      t.column :deliver_country_region_id, :string, :limit => 20
      t.column :deliver_date,              :date
      t.column :deliver_state,             :string
      t.column :deliver_street,            :string
      t.column :deliver_zip_code,          :string
      t.column :purch_order_form_num,      :string
      t.column :status,                    :string, :limit => 20
      t.column :updated_at,                :datetime
      t.column :closeed,                   :boolean, :default => false
    end

    add_index :ax_orders, :ax_order_number
    add_index :ax_orders, :ax_account_id

    create_table :ax_order_line_items do |t|
      t.column :ax_order_number,       :string, :limit => 20
      t.column :ax_order_id,           :integer
      t.column :confirmed_lv,          :date
      t.column :item_id,               :string, :limit => 20
      t.column :remain_sales_physical, :float
      t.column :sales_qty,             :float
      t.column :sales_unit,            :string, :limit => 20
      t.column :updated_at,            :datetime
    end

    add_index :ax_order_line_items, :ax_order_id
  end

  def self.down
    drop_table   :ax_accounts
    drop_table   :ax_orders
    drop_table   :ax_order_line_items
  end
end
