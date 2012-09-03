class SyncAxProduct < ActiveRecord::Base
  set_table_name "sync_ax_products"
  
  def self.get_delivery_code_equal_to_others(items)
    products = Product.find :all
    changed_products = products.select{|product| items.map(&:product_id).include?(product.id)}
    for_delivery_code_others_ids = changed_products.select{|product| product.delivery_code != 0 && product.delivery_code != 1}.map(&:id)
    @changed_items_for_code_equal_to_others = items.select{|item| for_delivery_code_others_ids.include?(item.product_id)}
  end
  
  def self.get_delivery_code_equal_to_0_1(items)
    products = Product.find :all
    changed_products = products.select{|product| items.map(&:product_id).include?(product.id)}
    for_delivery_code_0_1_ids = changed_products.select{|product| product.delivery_code == 0 || product.delivery_code == 1}.map(&:id)
    @changed_items_for_code_equal_to_0_1 = items.select{|item| for_delivery_code_0_1_ids.include?(item.product_id)}
  end  
end