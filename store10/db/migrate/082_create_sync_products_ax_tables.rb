class CreateSyncProductsAxTables < ActiveRecord::Migration
  def self.up
    create_table :sync_ax_products do |t|
      t.column "product_id",            :integer
      t.column "erp_product_item",      :string
      t.column "name",                  :string, :limit => 100
      t.column "price",                 :float, :default => 0.0
      t.column "quantity",              :integer, :default => 0
      t.column "deposit",               :float, :default => 0.0
      t.column "shipping_points",       :float, :default => 0.0
      t.column "product_status",        :string
      t.column "group_id",              :string
      t.column "dim_group_id",          :string
      t.column "model_group_id",        :string
      t.column "percent_deposit",       :float
      t.column "amount_deposit",        :float
      t.column "name_local",            :string, :limit => 100, :default => ""
      t.column "name_ax",               :string, :limit => 100, :default => ""
      t.column "price_local",           :float, :default => 0.0
      t.column "price_ax",              :float, :default => 0.0
      t.column "deposit_local",         :float, :default => 0.0
      t.column "deposit_ax",            :float, :default => 0.0
      t.column "shipping_points_local", :float, :default => 0.0
      t.column "shipping_points_ax",    :float, :default => 0.0
      t.column "is_ignore",             :boolean, :default => false
      t.column "status",                :string
    end
  end

  def self.down
    drop_table :sync_ax_products
  end
end
