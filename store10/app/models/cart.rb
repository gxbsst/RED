class Cart
  attr_reader :items, :reservations
  attr_accessor :quantity_error, :shipping_charge
  
  # Initializes the shopping cart
  def initialize
    empty!
  end
  
  # Empties or initializes the cart
  def empty!
    @items = []
    @reservations = []
    @total = 0.0
    @shipping_charge = 0.0
    @balance = 0.0
    @quantity_error = nil
  end
  
  def empty?
    @items.length == 0 and @reservations.length == 0
  end

  # Returns the sum of items' subtotal
  def total
    @total = items.inject(0.0) { |sum, order_line_item| sum + order_line_item.subtotal }
  end
  
  def has_buy_now_product?
    @items.select{|item| item.payment_method == 'buy_now' && item.product.buy_now_require_redone }.size > 0
  end
  
  def convert_all_to_deposit!
    items = @items.dup
    items.each do |item|
      if item.payment_method == 'buy_now' && item.product.accept_deposit == true
        remove_product(item.product, item.quantity, 'buy_now')
        add_product(item.product, item.quantity, 'deposit')
      end
    end
  end
  
  # Adds a product to our shopping cart
  def add_product(product, quantity=1, payment_method='deposit')
    item = @items.find { |i| i.product_id == product.id && i.payment_method == payment_method }
    if item
      item.quantity += quantity
      if item.quantity > 20
        item.quantity = 20
        @quantity_error="Only 20 Items may be added at one time. If you need to purchase additional items please contact customer service."
      end
    else
      @items << OrderLineItem.new(
        :product_id     => product.id,
        :quantity       => quantity,
        :unit_deposit   => product.deposit,
        :unit_price     => product.price,
        :payment_method => payment_method
      )
    end
  end
  
  # Removes all quantities of product from our cart
  def remove_product(product, quantity=1, payment_method='deposit')
    item = @items.find { |i| i.product_id == product.id && i.payment_method == payment_method }
    if item
      if item.quantity > quantity then
        item.quantity -= quantity
      else
        @items.delete(item)
      end
    end
  end
  
end