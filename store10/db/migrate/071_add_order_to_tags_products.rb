class AddOrderToTagsProducts < ActiveRecord::Migration
  def self.up
    add_column :products_tags, :product_sort_id, :integer
  end

  def self.down
    remove_column :product_sort_id, :order
  end
end
