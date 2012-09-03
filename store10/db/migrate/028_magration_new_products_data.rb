class MagrationNewProductsData < ActiveRecord::Migration
  def self.up
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    %w(products tags products_tags images images_products).each do |table|
      Fixtures.create_fixtures(File.dirname(__FILE__)+"/dev_data", table)
    end

    Product.find(:all).each do |product|
      product.update_attributes(:erp_product_item => product.code) if product.erp_product_item.blank?
      product.update_attributes(:deposit => product.price * 0.1)
    end

    execute "UPDATE products SET deposit = 0 where erp_product_item in (901001,901002,901003,901004,901005,901006)"
  end

  def self.down
  end
end
