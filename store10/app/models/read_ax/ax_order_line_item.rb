class AxOrderLineItem  < ActiveRecord::Base
  belongs_to :ax_order, :conditions => ['status <> ?', 'ERROR']

  PRODUCTS = Product.find(:all)
  COUNTRYS = Country.find(:all)
  
  # Validation item exists in the products table.
  def prepare_delivery_validation
    # return invalid message if item_id not exists in database.
    unless PRODUCTS.find {|p| p.erp_product_item == item_id}
      return "\"#{ax_order_number}\",\"invalid item_id\",\"Not found item_id [#{item_id}]\""
    end
  end
  
  def redone_serial_number_validation
    # return invalid message if no sales_item_reservation_number.
    if item_id == Product::REDONE_ERP_PRODUCT_ITEM && sales_item_reservation_number.blank?
      return "\"#{ax_order_number}\",\"invalid sales item_reservation_number\",\"RedOne serial number is null\""
    end
  end

  # --- short-circuit methods begin --- #
  def ax_account_number
    self.ax_order.ax_account_number
  end
  
  def ax_account_id
    self.ax_order.ax_account_id
  end
  
  def email_address
    self.ax_order.email_address
  end
  
  def first_name
    self.ax_order.first_name
  end
  
  def last_name
    self.ax_order.last_name
  end
  
  def item_name
    product = PRODUCTS.find {|p| p.erp_product_item == item_id }
    product.nil? ? "" : product.name
  end
  
  def serial_number
    self.sales_item_reservation_number
  end
  
  def purch_order_form_num
    self.ax_order.purch_order_form_num
  end
  
  def delivery_message
    product = PRODUCTS.find {|p| p.erp_product_item == item_id }
    product.nil? ? "" : product.delivery_message
  end
  
  def price
    product = PRODUCTS.find {|p| p.erp_product_item == item_id }
    product.nil? ? 0.0 : product.price
  end
  
  def sales_qty
    self[:sales_qty].to_i
  end
  
  def subtotal
    price * sales_qty
  end
  
  def remain_sales_physical
    self[:remain_sales_physical].blank? ? 0 : self[:remain_sales_physical]
  end
  
  def purchase_from_xfer?
    self.ax_order.purchase_from_xfer?
  end
  
  def invoice_country_region_id
    self.ax_order.invoice_country_region_id
  end
  
  def invoice_country
    country = COUNTRYS.find { |c| c.fedex_code == invoice_country_region_id }
    country.blank? ? "" : country.name
  end
  
  def delivery_country_region_id
    self.ax_order.delivery_country_region_id
  end
  
  def delivery_country
    country = COUNTRYS.find { |c| c.fedex_code == delivery_country_region_id }
    country.blank? ? "" : country.name
  end
  
  def created_date
    self.ax_order.created_date
  end
  # --- short-circuit methods end --- #
end
