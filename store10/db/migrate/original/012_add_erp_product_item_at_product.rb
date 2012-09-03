class AddErpProductItemAtProduct < ActiveRecord::Migration
  def self.up
    add_column :products,       :erp_product_item,    :string
    #RED ONE
    Product.find_by_code('100-01-001').update_attribute(:erp_product_item, '101001')
    #RED BASIC PRODUCTION PACK
    Product.find_by_code('600-01-K00').update_attribute(:erp_product_item, '603001')
    #RED PREMIUM PRODUCTION PACK
    Product.find_by_code('600-02-K00').update_attribute(:erp_product_item, '603002')
    #RED PEIME (f2.8) 300mm
    Product.find_by_code('200-01-001').update_attribute(:erp_product_item, '201001')
    #RED ONE POWER PACK
    Product.find_by_code('400-01-K00').update_attribute(:erp_product_item, '403001')
    #RED BRICK 140Wh Battery Pack
    Product.find_by_code('400-01-002').update_attribute(:erp_product_item, '401001')
    #RED CHARGER
    Product.find_by_code('400-01-003').update_attribute(:erp_product_item, '402001')
    #RED EVF Viewfinder
    Product.find_by_code('300-01-001').update_attribute(:erp_product_item, '301001')
    #RED LCD Screen (5.6")
    Product.find_by_code('300-02-002').update_attribute(:erp_product_item, '302001')
    #RED ARM
    Product.find_by_code('300-04-001').update_attribute(:erp_product_item, '604001')
    #RED EVF / LCD Extension Cable 3ft
    Product.find_by_code('300-03-001').update_attribute(:erp_product_item, '309001')
    #RED EVF / LCD Extension Cable 10ft
    Product.find_by_code('300-03-002').update_attribute(:erp_product_item, '309002')
    #RED DRIVER 320GB
    Product.find_by_code('500-01-001').update_attribute(:erp_product_item, '501001')
    #RED RAM 64GB
    Product.find_by_code('500-01-002').update_attribute(:erp_product_item, '501002')
    #RED FLASH (CF) Module
    Product.find_by_code('500-01-003').update_attribute(:erp_product_item, '502001')
    #RED FLASH (EX34) Module
    Product.find_by_code('500-01-004').update_attribute(:erp_product_item, '502002')
    #RED FLASH (SATA) Module
    Product.find_by_code('500-01-005').update_attribute(:erp_product_item, '502003')
    #RED RAW PORT Module
    Product.find_by_code('500-01-006').update_attribute(:erp_product_item, '502004')
    #RED PRIME SET
    Product.find_by_code('200-03-K00').update_attribute(:erp_product_item, '203001')
    #RED ZOOM (f2.8) CF 18 - 50mm
    Product.find_by_code('200-02-001').update_attribute(:erp_product_item, '202002')
    #RED B4 to P/L Mount Adaptor
    Product.find_by_code('700-01-001').update_attribute(:erp_product_item, '804003')
    #RED FD Mount (Canon)
    Product.find_by_code('700-01-002').update_attribute(:erp_product_item, '804002')
    #RED F Mount (Nikon)
    Product.find_by_code('700-01-003').update_attribute(:erp_product_item, '804004')
    #10'' LOGO STICKER
    Product.find_by_code('900-01-003').update_attribute(:erp_product_item, '901003')
    #6" LOGO STICKER
    Product.find_by_code('900-01-002').update_attribute(:erp_product_item, '901002')
    #3'' LOGO STICKER
    Product.find_by_code('900-01-001').update_attribute(:erp_product_item, '901001')
    #20" LOGO STICKER
    Product.find_by_code('900-01-004').update_attribute(:erp_product_item, '901004')
    #Buzzsaw (9'')
    Product.find_by_code('900-01-005').update_attribute(:erp_product_item, '901005')
    #Chainsaw (9'')
    Product.find_by_code('900-01-006').update_attribute(:erp_product_item, '901006')
    #RED 50-150mm T3 (f2.8) Zoom
    Product.find_by_code('200-04-001').update_attribute(:erp_product_item, '202003')
  end

  def self.down
    remove_column :products,       :erp_product_item
  end

end
