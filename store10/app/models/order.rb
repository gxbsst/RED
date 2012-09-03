class Order < ActiveRecord::Base
  # Associations
  has_many :order_line_items
  belongs_to :order_user
  belongs_to :order_account
  belongs_to :order_shipping_type
  belongs_to :order_status_code
  # Validation
  validates_presence_of :order_number
  validates_uniqueness_of :order_number
  has_many :order_transactions
  has_many :pfp_transactions
  @@handling_fee = 15.00
  
  # ---------- Class Methods Begin here ---------- #
  class << self
    require 'ostruct'
    
    # Compute  the cost with the dangerous goods
    def dangerous_goods_due( line_items, country_id )

      if line_items.select{|item| is_dangerous?(item) == true &&  item.payment_method == 'buy_now' && item.product.buy_now_require_redone }.size > 0 
        if country_id == 1
        return $DANGEROUS_GOODS_DUE["us"]
      else
        return $DANGEROUS_GOODS_DUE["another"]
      end
      else
        return 0 
      end
    end

    def is_dangerous?( item )
      if ERP::Item.find_by_item_id( item.product.erp_product_item ).dangerous 
        true
      end
    end
    
    # 计算OrderSummary并返回用Hash构造的OpenStruct对象
    def order_summary(line_items, shipping_address, current_shipping_charge=nil)
      # 计算税率
      tax_rate = shipping_address.tax_rate
      
      # 国家
      country = shipping_address.country
      country_id  = shipping_address.country_id
      
      # fedex的国家代码和区域代码
      fedex_country_code = country.fedex_code
      fedex_zone = country.fedex_zone
      
      # 地区
      state = shipping_address.state
      
      # 可以送货的产品总重量
      buy_now_shipping_points_complete_subtotal = line_items.inject(0.0) {|sum, i| sum + i.buy_now_shipping_points_subtotal}
      
      # 可以送货的运费选项
      # 计算结果有两种可能: [] or 可用运费列表
      # 如果buy_now_shipping_points_complete_subtotal等于零,表示没有今天可以送的产品,结果为[]
      buy_now_shipping_options = buy_now_shipping_points_complete_subtotal == 0.0 ? [] : ProductShippingRate.fedex_shipping_options(fedex_zone, buy_now_shipping_points_complete_subtotal)
      
      # 所有的产品总重量
      #shipping_points_complete_subtotal = line_items.inject(0.0) {|sum, i| sum + i.shipping_points_subtotal}
      
      # 总运费选项
      #shipping_options = ProductShippingRate.fedex_shipping_options(fedex_zone, shipping_points_complete_subtotal)
      
      # 可以送货的产品的运费的值有两种可能：0.0 or ProductShippingRate.instance.shipping_charge
      # 送货方式，送货方式的值有两种可能: '' or ProductShippingRate.instance.code
      if buy_now_shipping_options.empty?
        shipping_charge = 0.0
        delivery_mode = ''
      else
        current_shipping_select = buy_now_shipping_options.find {|i| i.shipping_charge.to_s == current_shipping_charge.to_s }
        if current_shipping_select.nil?
          shipping_charge = buy_now_shipping_options.first.shipping_charge
          delivery_mode   = buy_now_shipping_options.first.delivery_mode          
        else
          shipping_charge = current_shipping_select.shipping_charge
          delivery_mode   = current_shipping_select.delivery_mode
        end
      end
      #判断订单是否有危险产品，如果有判断是哪个国家，美国＋50，其他国家100
      dangerous_goods_due = dangerous_goods_due(line_items,country_id)
      
      shipping_charge += dangerous_goods_due
      # 现在付款购买需要支付的总现金
      buy_now_total  = line_items.select {|item| item.payment_method == 'buy_now'}.inject(0.0) {|sum, i| sum + i.subtotal }
      
      # 押金支付订货的总现金
      deposit_total  = line_items.select {|item| item.payment_method == 'deposit'}.inject(0.0) {|sum, i| sum + i.subtotal }
      
      # 现在付款购买和押金支付订货的总合
      subtotal = buy_now_total + deposit_total
      
      # 订单中产品的总合：sum(数量 X 单价)
      complete_total = line_items.inject(0.0) {|sum, i| sum + i.complete_subtotal }
      
      # 一共需要支付的税(估计税):
      estimated_sales_tax = ErpHelper.roundf(complete_total  * (tax_rate * 0.01))
      
      # 现在可以支付的税(估计税): 税率 X (现在可以支付的钱 + 可以送的货的运费)
      total_due_sales_tax = ErpHelper.roundf((tax_rate * 0.01) * (buy_now_total + shipping_charge))
      
      # 现在需要支付的总合：现在付款购买和押金支付订货的总合 + 现在需要支付的税 + 运费
      total_due = subtotal + total_due_sales_tax + shipping_charge
      

            
      # 订单中产品的总合 + 一共需要支付的税 - (现在付款购买和押金支付订货的总合 + 现在可以支付的税) + 危险品附加款(dangerous)
      estimated_balance = complete_total + estimated_sales_tax - subtotal - total_due_sales_tax 
      
      # 将OrderSummary的计算结果包装为OpenStruct对象并返回
      return OpenStruct.new({
          :tax_rate                                  => tax_rate,
          :fedex_country_code                        => fedex_country_code,
          :fedex_zone                                => fedex_zone,
          :state                                     => state,
          :buy_now_shipping_points_complete_subtotal => buy_now_shipping_points_complete_subtotal,
          :buy_now_shipping_options                  => buy_now_shipping_options,
          #:shipping_points_complete_subtotal         => shipping_points_complete_subtotal,
          #:shipping_options                          => shipping_options,
          :shipping_charge                           => shipping_charge,
          :delivery_mode                             => delivery_mode,
          :buy_now_total                             => buy_now_total,
          :deposit_total                             => deposit_total,
          :subtotal                                  => subtotal,
          :complete_total                            => complete_total,
          :estimated_sales_tax                       => estimated_sales_tax,
          :total_due_sales_tax                       => total_due_sales_tax,
          :total_due                                 => total_due,
          :estimated_balance                         => estimated_balance,
          :dangerous_goods_due                       => dangerous_goods_due
          })
    end
    
    # Searches an order
    # Uses order number, first name, last name
    def search(search_term, count=false, limit_sql=nil)
      if (count == true) then
        sql = "SELECT COUNT(*) "
      else
        sql = "SELECT DISTINCT orders.* "
      end
      sql << "FROM orders "
      sql << "JOIN order_addresses ON orders.order_user_id = order_addresses.order_user_id "
      sql << "WHERE orders.order_number = ? "
      sql << "OR order_addresses.first_name LIKE ? "
      sql << "OR order_addresses.last_name LIKE ? "
      sql << "ORDER BY orders.created_on DESC "
      sql << "LIMIT #{limit_sql}" if limit_sql
      arg_arr = [sql, search_term, "%#{search_term}%", "%#{search_term}%"]
      if (count == true) then
        count_by_sql(arg_arr)
      else
        find_by_sql(arg_arr)
      end
    end
  
    # Generates a unique order number.
    # This number isn't ID because we want to mask that from the customers.
    def generate_order_number
      record = Object.new
      while record
        random = rand(999999999)
        record = find(:first, :conditions => ["order_number = ?", random])
      end
      return random
    end
  
    # Returns array of sales totals (hash) for a given year.
    # Hash contains
    #   * :number_of_sales
    #   * :sales_total
    #   * :tax
    #   * :shipping
    def get_totals_for_year(year)
      months = Array.new
      0.upto(12) { |i|
        sql = "SELECT COUNT(*) AS number_of_sales, SUM(product_cost) AS sales_total, "
        sql << "SUM(tax) AS tax, SUM(shipping_cost) AS shipping "
        sql << "FROM orders "
        sql << "WHERE YEAR(created_on) = ? "
        if i != 0 then
          sql << "AND MONTH(created_on) = ? "
        end
        sql << "AND (order_status_code_id = 5 OR order_status_code_id = 6 OR order_status_code_id = 7) "
        sql << "LIMIT 0,1"
        if i != 0 then
          months[i] = self.find_by_sql([sql, year, i])[0]
        else
          months[i] = self.find_by_sql([sql, year])[0]
        end
      }
      return months
    end
  
    # Gets a CSV string that represents an order list.
    def self.get_csv_for_orders(order_list)
      csv_string = FasterCSV.generate do |csv|
        # Do header generation 1st
        csv << [
          "OrderNumber", "Company", "ShippingType", "Date", 
          "BillLastName", "BillFirstName", "BillAddress", "BillCity", 
          "BillState", "BillZip", "BillCountry", "BillTelephone", 
          "ShipLastName", "ShipFirstName", "ShipAddress", "ShipCity", 
          "ShipState", "ShipZip", "ShipCountry", "ShipTelephone",
          "Item1",
          "Quantity1", "Item2", "Quantity2", "Item3", "Quantity3", "Item4",
          "Quantity4", "Item5", "Quantity5", "Item6", "Quantity6", "Item7",
          "Quantity7", "Item8", "Quantity8", "Item9", "Quantity9", "Item10",
          "Quantity10", "Item11", "Quantity11", "Item12", "Quantity12", "Item13",
          "Quantity13", "Item14", "Quantity14", "Item15", "Quantity15", "Item16",
          "Quantity16"
        ]
        for order in order_list
          bill = order.billing_address
          ship = order.shipping_address
          pretty_date = order.created_on.strftime("%m/%d/%y")
          if !order.order_shipping_type.nil?
            ship_code = order.order_shipping_type.code
          else
            ship_code = ''
          end
          order_arr = [
            order.order_number, '', ship_code, pretty_date,
            bill.last_name, bill.first_name, bill.address, bill.city,
            bill.state, bill.zip, bill.country.name, bill.telephone,
            ship.last_name, ship.first_name, ship.address, ship.city,
            ship.state, ship.zip, ship.country.name, ship.telephone 
          ]
          item_arr = []
          # Generate spaces for items up to 16 deep
          0.upto(15) do |i|
            item = order.order_line_items[i]
            if !item.nil? && !item.product.nil?  then
              item_arr << item.product.code
              item_arr << item.quantity
            else
              item_arr << ''
              item_arr << ''
            end
          end
          # Add csv string by joining arrays
          csv << order_arr.concat(item_arr)
        end
      end
      return csv_string
    end
  
    # Returns an XML string for each order in the order list.
    # This format is for sending orders to Tony's Fine Foods
    def get_xml_for_orders(order_list)
      xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      xml << "<orders>\n"
      for order in order_list
        if order.order_shipping_type
          shipping_type = order.order_shipping_type.code
        else
          shipping_type = ''
        end
        pretty_date = order.created_on.strftime("%m/%d/%y")
        xml << "	<order>\n"
        xml << "		<date>#{pretty_date}</date>\n"
        xml << "		<shippingCode>#{shipping_type}</shippingCode>\n"
        xml << "		<invoiceNumber>#{order.order_number}</invoiceNumber>\n"
        xml << "		<emailAddress>#{order.order_user.email_address}</emailAddress>\n"
        # Shipping address
        address = OrderAddress.find_shipping_address_for_user(order.order_user)
        xml << "		<shippingAddress>\n"
        xml << "			<firstName>#{address.first_name}</firstName>\n"
        xml << "			<lastName>#{address.last_name}</lastName>\n"
        xml << "			<address1>#{address.address}</address1>\n"
        xml << "			<address2></address2>\n"
        xml << "			<city>#{address.city}</city>\n"
        xml << "			<state>#{address.state}</state>\n"
        xml << "			<zip>#{address.zip}</zip>\n"
        xml << "			<countryCode>#{address.country.fedex_code}</countryCode>\n"
        xml << "			<telephone>#{address.telephone}</telephone>\n"
        xml << "		</shippingAddress>\n"
        # Items
        xml << "		<items>\n"
        for item in order.order_line_items
          xml << "			<item>\n"
          xml << "				<name>#{item.product.name}</name>\n"
          xml << "				<id>#{item.product.code}</id>\n"
          xml << "				<quantity>#{item.quantity}</quantity>\n"
          xml << "			</item>\n"
        end
        xml << "		</items>\n"
        # End
        xml << "	</order>\n"
      end
      # End orders
      xml << "</orders>\n"
      return xml
    end
  end
  
  def self.find_by_store_user_id( store_user_id )
    find(
      :all,
      :select => "orders.*",
      :joins => "left outer join order_users on order_users.id = orders.order_user_id left outer join store_users on store_users.id = order_users.store_user_id",
      :conditions => ["store_users.id = ? AND orders.created_on > CURRENT_DATE()", store_user_id],
      :order => "orders.id desc"
    )
  end
  
  # ---------- Instance Methods Begin Here ---------- #
  # Order status name
  def status
    code = OrderStatusCode.find(:first, :conditions => ["id = ?", self.order_status_code_id])
    code.name
  end
  
  # Shortcut to items
  def items
    self.order_line_items
  end
  
  # Total for the order
  def total
    self.line_items_total + self.shipping_cost
  end
  
  # detect this order if include more than one redone body.
  def include_redone?
    order_line_items.map{ |item| item.product.erp_product_item }.detect{ |erp_product_item| erp_product_item == Product::REDONE_ERP_PRODUCT_ITEM }
  end
  
  def name
    begin
      return "#{shipping_address.first_name} #{shipping_address.last_name}"
    rescue Exception => e
      return "Error getting name please contact dev"
    end
  end
  
  def account
    self.order_user.order_account
  end
  
  def billing_address
    puts self.to_yaml if self.order_user.blank?
    OrderAddress.find_billing_address_for_user(self.order_user)
  end
  
  def shipping_address
    puts self.to_yaml if self.order_user.blank?
    OrderAddress.find_shipping_address_for_user(self.order_user)
  end
  
  # compute order summary
  def order_summary
    Order.order_summary(order_line_items, order_user.store_user.ship_to_address, shipping_cost)
  end
  
  # Sets line items from the product output table on the edit page.
  #
  # Deletes any line items with a quantity of 0.
  # Adds line items with a quantity > 0.
  #
  # This is called from update in our controllers.
  # What's passed looks something like this...
  #   @products = {'1' => {'quantity' => 2}, '2' => {'quantity' => 0}, etc}
  def line_items=(products)
    # Clear out all line items
    self.order_line_items.clear
    # Go through all products
    products.each do |id, product|
      quantity = product['quantity']
      if quantity.blank? then
        quantity = 0
      else
        quantity = Integer(quantity)
      end
      
      if (quantity > 0) then
        new_item = self.order_line_items.build
        logger.info("\n\nBUILDING NEW LINE ITEM\n")
        logger.info(new_item.inspect+"\n")
        new_item.quantity = quantity
        new_item.product_id = id
        new_item.unit_price = Product.find(:first, :conditions => "id = #{id}").price
        new_item.save
      end
    end
  end
  
  # Do we have a valid transaction id
  def contains_valid_transaction_id?()
    return (!self.auth_transaction_id.blank? && self.auth_transaction_id != 0)
  end

  def unique_order_line_items
    line_items = []
    order_line_items.each do |item|
      if current_item = line_items.find {|i| i.product_id == item.product_id }
        current_item.quantity += item.quantity
      else
        line_items << item
      end
    end
    return line_items
  end
  
  # Determines if an order has a line item based on product id
  def has_line_item?(id)
    self.unique_order_line_items.each do |item|
      return true if item.product_id == id
    end
    return false
  end
  
  # Gets quantity of a product if exists in current line items.
  def get_line_item_quantity(id)
    self.unique_order_line_items.each do |item|
      return item.quantity if item.product_id == id
    end
    return 0
  end
  
  # Gets a subtotal for line items based on product id
  def get_line_item_total(id)
    self.unique_order_line_items.each do |item|
      return item.subtotal if item.product_id == id
    end
    return 0
  end
  
  # Grabs the total amount of all line items associated with this order
  def line_items_total
    order_line_items.inject(0.0) {|sum, i| sum + i.subtotal }
  end
  
  # Adds a new order note from the edit page.
  #
  # We display notes as read-only, so we only have to use a text field
  # instead of multiple records.
  def new_notes=(note)
    if !note.blank? then
      time = Time.now.strftime("%m-%d-%y %I:%M %p")
      new_note = "<p>#{note}<br/>"
      new_note << "<span class=\"info\">"
      new_note << "[#{time}]"
      new_note << "</span></p>"
      if self.notes.blank? then
        self.notes = new_note
      else
        self.notes << new_note
      end
    end
  end
  
  # Calculates the weight of an order
  def weight
    weight = 0
    self.order_line_items.each do |item|
      weight += item.quantity * item.product.weight
    end
    return weight
  end
  
  # Gets a flat shipping price for an order.
  # This is if we're not using live rate calculation usually
  #
  # A lot of people will want this overridden in their app
  def get_flat_shipping_price
    return @@handling_fee
  end
  
  # Gets all LIVE shipping prices for an order.
  #
  # Returns an array of OrderShippingTypes
  def get_shipping_prices
    prices = Array.new
    # If they're in the USA
    address = self.shipping_address
    if address.country_id == 1 then
      shipping_types = OrderShippingType.get_domestic
    else 
      shipping_types = OrderShippingType.get_foreign
    end
    
    ship = Shipping::FedEx.new(:prefs => "#{RAILS_ROOT}/config/shipping.yml")
    ship.fedex_url = SHIP_FEDEX_URL
    ship.fedex_account = SHIP_FEDEX_ACCOUNT
    ship.fedex_meter = SHIP_FEDEX_METER
    ship.sender_zip = SHIP_SENDER_ZIP
    ship.sender_country = SHIP_SENDER_COUNTRY
    ship.weight = self.weight
    ship.zip = address.zip
    ship.city = address.city
    ship.country = address.country.fedex_code
    
    logger.info("\n\nCREATED A SHIPPING OBJ\n#{ship.inspect}\n\n")
    
    for type in shipping_types
      ship.service_type = type.service_type
      ship.transaction_type = type.transaction_type
      # Rescue errors. The Shipping gem likes to throw nasty errors
      # when it can't get a price.
      #
      # Usually this means the customer didn't enter a valid address (zip code most of the time)
      # In that case we go for our own shipping prices.
      begin
        # FedEx can be flaky sometimes and return 0 for prices.
        # Make sure we always calculate a shipping rate even if they're being wacky.
        price = ship.discount_price
        if price == 0
          price = ship.price
        end
        if price == 0
          type.calculate_price(self.weight)
        else
          type.price = price + @@handling_fee
        end
      rescue
        logger.error "\n[ERROR] #{$!.message}"
        type.calculate_price(self.weight)
        type.price += @@handling_fee
      end
      #    logger.info "#{type.name} : ship.discount_price / type.price"
      prices << type
    end
    
    return prices
    
  end
  
  # Creates a general transaction
  # Load it with our defaults
  def create_transaction
    # If you don't load the prefs file rails throws some errors
    # ALTHOUGH I couldn't get the prefs to load properly from the yml file.
    trans = Payment::AuthorizeNet.new(:prefs => "#{RAILS_ROOT}/config/payment.yml")
    trans.login = PAY_LOGIN
    trans.password = PAY_PASS
    # If the URL is defined as a constant set it here
    # If not defined it connects to Authorize.net's default server
    # You can use this for Auth.net test accounts OR 2Checkout.com (in theory)
    trans.url = PAY_URL if PAY_URL != nil
    # The AIM guide says this is necessary, but I've gotten
    # away without using it before (you can use this or password)
    trans.transaction_key = PAY_TRANS_KEY if PAY_TRANS_KEY != nil
    # All this stuff should really be in get_auth_transaction
    # But the payment.rb gateway for SOME reason wants most of this crap
    # even though it's not required for a VOID.
    trans.amount = self.total
    trans.first_name = self.billing_address.first_name
    trans.last_name = self.billing_address.last_name
    trans.address = self.billing_address.address
    trans.city = self.billing_address.city
    trans.state = self.billing_address.state
    trans.zip = self.billing_address.zip
    trans.country = self.billing_address.country.name
    trans.card_number = self.account.cc_number
    expiration = "#{self.account.expiration_month}/#{self.account.expiration_year}"
    trans.expiration = expiration
    # Set this to a test transaction if not in production mode
    # Just a safeguard!
    if ENV['RAILS_ENV'] != "production" then
      trans.test_transaction = true
    end
    logger.info("\n\nCreated a credit card transaction\n")
    logger.info(trans.inspect)
    return trans
  end
  
  # Gets a transaction ready to be sent for payment processing
  def get_auth_transaction
    trans = self.create_transaction
    # Set order specific fields
    trans.type = 'AUTH_CAPTURE'
    return trans
  end
  
  # Gets a transaction ready to be voided
  def get_void_transaction
    trans = self.create_transaction
    # This is necessary for voiding an order
    # Return nil if we don't have a record of the transaction id
    if !self.contains_valid_transaction_id? then
      return nil
    else
      trans.transaction_id = self.auth_transaction_id
    end
    trans.type = 'VOID'
    return trans
  end
  
  # Cleans up a successful order
  def cleanup_successful
    self.order_status_code_id = 5
    self.new_notes="Order completed."
    self.product_cost = self.line_items_total
    self.account.clear_personal_information
    self.save
  end
  
  # Cleans up a failed order
  def cleanup_failed(msg)
    self.order_status_code_id = 3
    self.new_notes="Order failed!<br/>#{msg}"
    self.save
  end
  
  
  # We define deliver_receipt here because ActionMailer can't seem to render
  # components inside a template.
  #
  # I'm getting around this by passing the text into the mailer.
  def deliver_receipt
    @content_node = ContentNode.find(:first, :conditions => ["name = ?", 'OrderReceipt'])
    OrdersMailer.deliver_receipt(self, @content_node.content)
  end
  
  # If we're going to define deliver_receipt here, why not wrap deliver_failed as well?
  def deliver_failed
    OrdersMailer.deliver_failed(self)
  end
  
  def order_transactions_amount
    order_transactions.inject(0) { | sum, order_transaction | order_transaction.viaklix_transaction ? order_transaction.viaklix_transaction.ssl_amount + sum : sum }
  end
  

end
