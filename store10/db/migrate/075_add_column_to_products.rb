class AddColumnToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :updated_at, :datetime
    add_column :products, :created_at, :datetime
    add_column :products, :product_status, :string
    add_column :products, :group_id, :string
  end

  def self.down
    remove_column :products, :updated_at
    remove_column :products, :created_at
    remove_column :products, :product_status
    remove_column :products, :group_id
  end
end
