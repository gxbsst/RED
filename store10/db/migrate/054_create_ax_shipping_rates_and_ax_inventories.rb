class CreateAxShippingRatesAndAxInventories < ActiveRecord::Migration
  def self.up
    create_table :ax_shipping_rates do |t|
      t.column :shipping_zone, :string, :null => false, :default => "", :limit => 10
      t.column :code,          :string, :null => false, :default => "", :limit => 10
      t.column :min_points,    :float,  :null => false, :default => 0.0
      t.column :max_points,    :float,  :null => false, :default => 0.0
      t.column :retail_price,  :float,  :null => false, :default => 0.0
      t.column :status,        :string, :null => false, :default => "EMPTY", :limit => 10
      t.column :updated_at,    :datetime
    end
    add_index :ax_shipping_rates, :shipping_zone
    add_index :ax_shipping_rates, :code
    add_index :ax_shipping_rates, :min_points
    add_index :ax_shipping_rates, :max_points
    add_index :ax_shipping_rates, :retail_price
    
    create_table :ax_inventories do |t|
      t.column :dim_group_id,    :string, :null => false, :defalut => "", :limit => 10
      t.column :item_group_id,   :string, :null => false, :defalut => "", :limit => 10
      t.column :item_id,         :string, :null => false, :defalut => "", :limit => 10
      t.column :item_name,       :string, :null => false, :default => ""
      t.column :item_price,      :float,  :null => false, :default => 0.0
      t.column :model_group_id,  :string, :null => false, :defalut => "", :limit => 10
      t.column :pct_deposit,     :float,  :null => false, :default => 0.0
      t.column :amt_deposit,     :float,  :null => false, :default => 0.0
      t.column :shipping_points, :float,  :null => false, :default => 0.0
      t.column :status,          :string, :null => false, :defalut => "EMPTY", :limit => 10
      t.column :updated_at,      :datetime
    end
    add_index :ax_inventories, :item_id
    add_index :ax_inventories, :item_name
    add_index :ax_inventories, :item_price
    add_index :ax_inventories, :pct_deposit
    add_index :ax_inventories, :amt_deposit
  end

  def self.down
    drop_table :ax_shipping_rates
    drop_table :ax_inventories
  end
end
