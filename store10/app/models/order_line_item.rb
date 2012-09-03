class OrderLineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order

  def name
    product.blank? ? "Item has been deleted." : product.name
  end
  
  # item's quantity multiply current payment method's price
  def subtotal
    case
    when self.payment_method == 'buy_now' : price = unit_price
    when self.payment_method == 'deposit' : price = unit_deposit
    else
      price = 0.0
    end
    quantity * price
  end
  
  # item's quantity multiply unit price
  def complete_subtotal
    quantity * unit_price
  end
  
  def shipping_points_subtotal
    quantity * product.shipping_points
  end
  
  def buy_now_shipping_points_subtotal
    payment_method == 'buy_now' ? (quantity * product.shipping_points) : 0.0
  end
end
