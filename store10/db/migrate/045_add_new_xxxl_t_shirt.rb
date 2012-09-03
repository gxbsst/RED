class AddNewXxxlTShirt < ActiveRecord::Migration
  T_shirts = [
    ['902024','T-Shirt w/ Logo - Men - Black - 4XL'],
    ['902025','T-Shirt w/ Logo - Men - White - 4XL'],
    ['902026','T-Shirt w/ Logo - Men - Red - 4XL']
  ]
  
  def self.up
    T_shirts.each do |t_shirt|
      Product.create(
        :code              => t_shirt.first,
        :name              => t_shirt.last,
        :description       => t_shirt.last,
        :price             => 20.0,
        :date_available    => Date.today.to_s(:db),
        :erp_product_item  => t_shirt.first,
        :deposit           => 0.0
      )
    end
  end

  def self.down
    Product.find(:all, :conditions => ['code in (?)', T_shirts.map{|t_shirt| t_shirt.first}]).each {|product| product.destroy }
  end
end
