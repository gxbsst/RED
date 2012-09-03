class AddColumnsToProductsForOrder < ActiveRecord::Migration
  def self.up
    add_column :products, :is_featured, :boolean, :default => false, :null => false
    add_column :products, :sequence, :integer
    add_column :products, :end_of_line, :boolean, :default => false
  end
  
  def self.down
    remove_column :products, :is_featured
    remove_column :products, :sequence
    remove_column :products, :end_of_line
  end
end