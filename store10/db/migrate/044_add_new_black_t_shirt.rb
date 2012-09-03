class AddNewBlackTShirt < ActiveRecord::Migration
  T_shirts = [
    ['902017','T-Shirt w/ Logo - Men - Black - M'],
    ['902018','T-Shirt w/ Logo - Men - Black - L'],
    ['902019','T-Shirt w/ Logo - Men - Black - XL'],
    ['902020','T-Shirt w/ Logo - Men - Black - XXL'],
    ['902021','T-Shirt w/ Logo - Women - Black - S'],
    ['902022','T-Shirt w/ Logo - Women - Black - M'],
    ['902023','T-Shirt w/ Logo - Women - Black - L']
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
