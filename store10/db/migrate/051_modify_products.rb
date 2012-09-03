class ModifyProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :accept_deposit,  :boolean, :null => false, :default => true
    add_column :products, :accept_buy_now,  :boolean, :null => false, :default => true
    add_column :products, :shipping_points, :float,   :null => false, :default => 0.0
    
    Product.find_all_by_erp_product_item(Product::REDONE_ERP_PRODUCT_ITEM).each { |item| item.update_attributes(:accept_deposit => true, :accept_buy_now => false) }
    Product.find_all_by_erp_product_item(Product::PAID_TODAY_ERP_PRODUCT_ITEMS).each { |item| item.update_attributes(:accept_deposit => false, :accept_buy_now => true) }
  end

  def self.down
    remove_column :products, :accept_deposit
    remove_column :products, :accept_buy_now
    remove_column :products, :shipping_points
  end
end
