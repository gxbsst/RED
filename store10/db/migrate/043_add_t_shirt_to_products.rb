class AddTShirtToProducts < ActiveRecord::Migration
  T_shirts = [
    ['902001','T-Shirt w/ Logo - Men - White - M'],
    ['902002','T-Shirt w/ Logo - Men - White - L'],
    ['902003','T-Shirt w/ Logo - Men - White - XL'],
    ['902004','T-Shirt w/ Logo - Men - White - XXL'],
    ['902005','T-Shirt w/ Logo - Men - Red - M'],
    ['902006','T-Shirt w/ Logo - Men - Red - L'],
    ['902007','T-Shirt w/ Logo - Men - Red - XL'],
    ['902008','T-Shirt w/ Logo - Men - Red - XXL'],
    ['902009','T-Shirt w/ Logo - Women - White - S'],
    ['902010','T-Shirt w/ Logo - Women - White - M'],
    ['902011','T-Shirt w/ Logo - Women - White - L'],
    ['902012','T-Shirt w/ Logo - Women - White - XL'],
    ['902013','T-Shirt w/ Logo - Women - Red - S'],
    ['902014','T-Shirt w/ Logo - Women - Red - M'],
    ['902015','T-Shirt w/ Logo - Women - Red - L'],
    ['902016','T-Shirt w/ Logo - Women - Red - XL']
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
