class CreateErpItems < ActiveRecord::Migration
  def self.up
    create_table :erp_items do |t|
      t.column :item_id,            :string, :null => false,  :defalut => ""
      t.column :name,               :string, :null => false,  :default => ""
      t.column :quantity,           :integer,:null => false,  :default => 0
      t.column :group_id,           :string, :null => false,  :defalut => ""
      t.column :dim_group_id,       :string, :null => false,  :defalut => ""
      t.column :model_group_id,     :string, :null => false,  :defalut => ""
      t.column :price,              :float
      t.column :percent_deposit,    :float
      t.column :amount_deposit,     :float
      t.column :shipping_points,    :float
      t.column :created_at,         :datetime
      t.column :updated_at,         :datetime
    end
  end

  def self.down
    drop_table :erp_items
  end
end
