class StoreController < ApplicationController
  # New layout with a white background
  layout proc{ |controller|
    if ['index', 'product_detail', 'tags','show_by_tags', 't_shirt', 'red_caps'].include?(controller.action_name)
      return 'white_store'
    else
      return 'main'
    end
  }
  
  require "net/http"
  require "net/https"
  require 'uri'
  require "erb"
  include ERB::Util
  include OrderHelper
  
  before_filter :before_show_by_tags, :only => :show_by_tags
  
  def redirect_to_ssl params
    if ENV['RAILS_ENV'] == "production"
      redirect_to url_for(params.merge({:protocol => 'https://'}))
    else
      redirect_to params
    end
  end
  
  # Helper :number
  # Our simple store index
  # ========
  # New layouts for store index.
  # Modified by Jerry @ 2007-09-06
  def index
    @page_title = 'RED STORE'
    @cart = find_cart
    puts @cart.items.inspect
    
    @products = Product.find(:all, :conditions => ["is_featured = ?", 1], :order => "sequence" )
    # Product.find(:all, :conditions => "code <> ''").each { |product| @products.merge!(product.code => product) }
    # Product.find(:all, :conditions => ["is_featured = ?", 1], :order => "sequence" ).each { |product| @products.merge!(product.erp_product_item => product) }
  end
  
  def t_shirt
    @cart = find_cart
  end
  
  # Customized page for RED caps with different size.
  def red_caps
    @cart = find_cart
    @product = Product.find_by_code('903001')
    @product.name = 'RED Caps' # overwrite product's name but DO NOT save its
    @customized_template = 'red_caps'
    @image = @product.images.first
    render :action => 'product_detail'
  end
  
  def checkout
    @title = 'Checkout'
    @cart = find_cart
    @items = @cart.items
    
    redirect_to_index("You've not chosen to buy any items yet. Please select an item from this page.") if @items.empty?
    
    return unless request.post?
    
    store_user = StoreUser.find_by_email_address_and_password(params[:login], params[:password])
    if store_user
      session[:store_user_id] = store_user.id
      if @cart.has_buy_now_product? && !store_user.has_already_received_redone? && !store_user.purchased
        # detect store_user has already received redone body
        #   true: pass throught if user has redone body
        #   false: convert all buy_now_require_redone product's payment_method to 'deposit'
        @cart.convert_all_to_deposit!
        flash[:notice] = "<p>Unfortunately we were unable to locate RED ONE delivery information for your account. To make best use of available inventory, immediate delivery is only available to clients who have already taken delivery of RED ONE. If you have already taken delivery of RED ONE please use the <a href='http://red.com/contact_us'>Contact Us</a> form to correct this issue.</p><p><br/>All of the \"BUY NOW\" items on your order have been converted to \"DEPOSIT\" items.</p>"
      end
      if store_user.ship_to_address.nil?
        redirect_to_ssl :action => 'ship_to'
        return
      else
        redirect_to_ssl :action => 'bill_to'
        return
      end
    else
      flash[:notice] = "Invalid username or password. If you need to reset your password please click 'Forgot password?'. Thank you."
    end
  end
  
  def create_account
    cart = find_cart
    if cart.empty?
      redirect_to_index("Your cart is empty. Please make sure cookies are enabled and proceed to checkout")
      return false
    end
    
    @title = "Create Account"
    if request.post?
      @store_user = StoreUser.new(params[:store_user])
      
      errors = @store_user.errors
      if @store_user.confirm_email != @store_user.email_address
        errors.add(:match_error, "Email and Confirm Email must Match")
      end
      if @store_user.confirm_password != @store_user.password
        errors.add(:match_error, "Password and Confirm Password must Match")
      end
      
      if errors.empty? and @store_user.save
        # @order.store_user = @store_user
        session[:store_user_id] = @store_user.id
        redirect_to_ssl :action => 'ship_to'
      else
        flash[:notice] = errors.full_messages.join("<br />")
      end
    else
      @store_user = StoreUser.new
    end
  end
  
  def ship_to
    @cart = find_cart
    if @cart.empty?
      redirect_to_index("Your cart is empty. Please make sure cookies are enabled and proceed to checkout")
      return
    end
    
    #=======================================================
    # Auto fill in first/last name and company for next page
    #=======================================================
    store_user = StoreUser.find_by_id(session[:store_user_id])
    if store_user.name =~ /([^\s]*)\s(.*)/
      first_name = $1
      last_name  = $2
    else
      first_name = store_user.name
      last_name  = ''
    end
    
    @title = "Ship To"
    @order_address = OrderAddress.new(:company => store_user.company, :first_name => first_name, :last_name => last_name)
    
    return unless request.post?
    
    # don't do a thing...
    @order_address = OrderAddress.new(params[:order_address])
    @order_address.is_shipping = true
    if @order_address.valid?
      store_user.ship_to_address = @order_address
      
      begin
        store_user.save!
      rescue
        flash[:notice] = store_user.errors.full_messages.join("<br />")
        redirect_to_ssl :action => 'checkout'
        return
      end
      
      redirect_to_ssl :action => 'bill_to'
    else
      flash[:notice] = @order_address.errors.full_messages.join("<br />")
    end
  end
  
  def ship_to_edit
    @cart = find_cart
    redirect_to_index("Your cart is empty. Please make sure cookies are enabled and proceed to checkout") if @cart.empty?
    
    @title = "Ship To (Edit)"

    store_user = StoreUser.find_by_id(session[:store_user_id])
    if request.post?
      @order_address = OrderAddress.new(params[:order_address])
      @order_address.is_shipping = true
      if @order_address.valid?
        store_user.ship_to_address = @order_address
        store_user.save!
        
        # purge @cart.shipping_charge when edit shipping address.
        @cart.shipping_charge = 0.0
        
        redirect_to_ssl :action => 'confirm'
      else
        flash[:notice] = @order_address.errors.full_messages.join("<br />")
        render :action => 'ship_to'
      end
    else
      @order_address = store_user.ship_to_address
      #flash[:notice] = @order_address.to_json
      render :action => 'ship_to'
    end
  end
  
  def bill_to
    
    # flash.now[:notice] ||= "" << "<p><br/>We reserve the right to refuse any order placed on the website.<br>\n If your order has been canceled the full amount charged on your CC will be fully refunded.</p>"
    
    @cart = find_cart
    if @cart.empty?
      redirect_to_index("Your cart is empty. Please make sure cookies are enabled and proceed to checkout")
    end
    
    @title = "Bill To"
    store_user = StoreUser.find_by_id(session[:store_user_id])
    
    # =======================================================
    # Force redirect to 'ship_to' if ship_to_address is nil
    # =======================================================
    if store_user.ship_to_address.nil?
      redirect_to_ssl :action => 'ship_to'
      return
    end
    
    if @cart.total >= AppConfig.CC_PAYMENT_LIMIT
      flash.now[:notice] ||= "" << "<p><br/>NOTE: RED only accepts credit card payments orders for up to $#{AppConfig.CC_PAYMENT_LIMIT.to_i}.<br>\n You will need to use a Wire Transfer to complete this payment.</p>"
    end
    
    # =======================================================
    # Write a 'cookies_key' for cookies
    # =======================================================
    unless cookies[:cookies_key]
      cookies[:cookies_key] = CreditCard.cookies_key(request)
    end
    
    @order_account = store_user.order_account
    @order_address = store_user.bill_to_address
    unless @order_account
      @order_account = OrderAccount.new
    end
    unless @order_address
      @order_address = store_user.ship_to_address.clone
      @order_address.is_shipping = false
    end
    
    # =======================================================
    # Return CC# and credit_ccv when PFP declined request
    # =======================================================
    unless session[:aes_cc_number].blank?
      @order_account.cc_number  = CreditCard.decrypt(self, 'cc_number')
      @order_account.credit_ccv = CreditCard.decrypt(self, 'credit_ccv')
    end
    
    if request.post?
      @order_account.attributes = params[:order_account]
      @order_address.attributes = params[:order_address]
      
      if params[:order_account][:payment_type].to_i == 0
        #===============================================
        # Validate cc number
        #===============================================
        validate_result = CreditCard.validate(params)
        if validate_result.shift
          #=============================================
          # Encrypted cc number
          #=============================================
          CreditCard.encrypt(self)
        else
          flash[:notice] = validate_result.shift.join("<br />")
          return
        end
      end
      
      if @order_address.valid? and @order_account.valid?
        unless store_user.order_account
          store_user.order_account = @order_account
        end
        unless store_user.bill_to_address
          store_user.bill_to_address = @order_address
        end
        
        store_user.save!
        @order_account.save!
        @order_address.save!
        
        redirect_to_ssl :action => 'terms'
      else
        flash[:notice] = @order_account.errors.full_messages + @order_address.errors.full_messages
        return
      end
    end
  end
  
  def terms
    @agreement = Agreement.find(:first).latest_version
    
    begin
      if request.post?
        if params[:commit] == "Accept"
          session[:agreement_log] = AgreementLog.new(
            :remote_ip   => request.remote_ip,
            :agreement   => @agreement,
            :store_user  => StoreUser.find_by_id(session[:store_user_id]),
            :http_header => request.env.to_yaml
          )
          redirect_to_ssl :action => "confirm"
        else
          redirect_to_index("You must choose to accept RED's Terms & Conditions to place an order")
          return
        end
      end
    rescue
      redirect_to_ssl :action => 'terms'
    end
  end
  
  def confirm
    @cart = find_cart
    if @cart.empty?
      redirect_to_index("Your cart is empty. Please make sure cookies are enabled and proceed to checkout")
      return
    end
    @title = "Confirm"
    
    store_user = StoreUser.find_by_id(session[:store_user_id])
    
    if store_user.ship_to_address.nil?
      redirect_to_ssl :action => 'ship_to'
    elsif store_user.bill_to_address.nil? && store_user.order_account.payment_type == 0
      redirect_to_ssl :action => 'bill_to'
    elsif session[:aes_cc_number].blank? && store_user.order_account.payment_type == 0
      redirect_to_ssl :action => 'bill_to'
    end
    
    @ship_to = store_user.ship_to_address
    @bill_to = store_user.bill_to_address
    
    @payment = store_user.order_account

    if @cart.total >= AppConfig.CC_PAYMENT_LIMIT and @payment.credit_card_payment?
      flash[:notice] = "NOTE: RED only accepts credit card payments orders for up to $#{AppConfig.CC_PAYMENT_LIMIT.to_i}.<br>\n You will need to use a Wire Transfer to complete this payment."
      redirect_to_ssl :action => 'bill_to'
      return
    end
    
    # initialize order_summary for compute order summary
    @order_summary = Order.order_summary(@cart.items, @ship_to, @cart.shipping_charge)
    # refresh @cart.shipping_charge from @order_summary
    @cart.shipping_charge = @order_summary.shipping_charge
    if @cart.shipping_charge == 0.0 && @cart.items.select{|item| item.payment_method == 'buy_now' }.size > 0
      flash.now[:notice] ||= "" << "There is not delivery method on file for your location. Please <a href='http://red.com/contact_us'>Contact Us</a> and we'll help you find a delivery method."
      @cart.convert_all_to_deposit!
    end
    
    return unless request.post?

    # Check to see if we are just doing an update, this probably should be moved elsewhere
    if params.include? 'update'
      # construct new items data by parse params[:items]
      # params[:items] might be like this:
      #   {"35,buy_now"=>"3", "35,deposit"=>"4"}      
      # the pattern of params[:items] is:
      #   {"id,payment_method" => "quantity"}
      # the contruct of parse result should be:
      #   {:id => id, :payment_method => payment_method, :quantity => quantity}
      new_items = params[:items].map {|k,v| {:id => k.split(',').first.to_i, :payment_method => k.split(',').last, :quantity => v.to_i} }
      
      @cart.items.each do |item|
        new_item = new_items.find {|i| i[:id] == item.product_id && i[:payment_method] == item.payment_method }
        if new_item
          product = item.product
          if item.quantity > new_item[:quantity]
            @cart.remove_product(product, item.quantity - new_item[:quantity], item.payment_method)
          elsif item.quantity < new_item[:quantity]
            @cart.add_product(product, new_item[:quantity] - item.quantity, item.payment_method)
          end
        end
      end
      
      # Update shipping charge
      # Refresh @order_summary after update cart
      @order_summary = Order.order_summary(@cart.items, @ship_to, params[:shipping_charge])
      # refresh @cart.shipping_charge from @order_summary
      @cart.shipping_charge = @order_summary.shipping_charge
      
      return
    end
    
    if @cart.has_buy_now_product? && !store_user.has_already_received_redone? && !store_user.purchased
      # detect store_user has already received redone body
      #   true: pass throught if user has redone body
      #   false: convert all buy_now_require_redone product's payment_method to 'deposit'
      @cart.convert_all_to_deposit!
      flash[:notice] = "<p>Unfortunately we were unable to locate RED ONE delivery information for your account. To make best use of available inventory, immediate delivery is only available to clients who have already taken delivery of RED ONE. If you have already taken delivery of RED ONE please use the <a href='http://red.com/contact_us'>Contact Us</a> form to correct this issue.</p><p><br/>All of the \"BUY NOW\" items on your order have been converted to \"DEPOSIT\" items.</p>"
      return
    end
    
    order = Order.new(
      :pre_ax => 0,
      :erp_order_uuid => UUID.random_create.to_s,
      :erp_account_uuid => UUID.random_create.to_s,
      :erp_cc_uuid => UUID.random_create.to_s
    )
    order.order_line_items = @cart.items
    order.order_number = Order.generate_order_number 
    
    order.order_account = @payment.clone
    order.order_account.order_address = @bill_to.clone
    
    order_user = OrderUser.new
    order_user.email_address = store_user.email_address
    order_user.password = store_user.password
    order_user.name = store_user.name
    order_user.company = store_user.company
    order.order_user = order_user
    
    order_user.order_addresses << @ship_to.clone
    
    order_user.order_addresses << order.order_account.order_address
    order_user.order_account = order.order_account
    
    order_user.store_user = store_user
    
    if store_user.name =~ /([^\s]*)\s(.*)/
      first_name = $1
      last_name  = $2
    else
      first_name = store_user.name
      last_name  = ''
    end
    
    # save shipping charge to order
    order.shipping_cost = @cart.shipping_charge
    
    #==============================================
    # PFP Transaction begin
    #==============================================
    if @payment.credit_card_payment?
      begin
        pfp_response = CreditCard.pfp_process(self, order)
      rescue EOFError => ex
        flash[:notice] = "Error processing order (Transaction Timeout).<br />Please try again or <a href='/contactus.htm'>Contact Us</a> to report this problem and complete your order"
        return
      rescue Exception => ex
        flash[:notice] = "Error processing order.<br />Please <a href='/contactus.htm'>Contact Us</a> to report this problem and complete your order"
        #ErpHelper.logger ex.message
        #ErpHelper.logger ex.backtrace.join("\n")
        return
      end
      
      #============================================
      # PFP Transaction Result
      #============================================
      unless pfp_response.first
        flash[:notice] = pfp_response.last.to_s
        redirect_to_ssl :action => 'bill_to'
        return
      end
      
    elsif @payment.wire_transfer_payment?
      order.order_status_code_id = 14 # Yuck this really needs to be defined in Order or OrderStatusCode
    end
    
    # Check the Fraud
    order.order_status_code_id = 15 if is_fraud?
    
    begin
      order.class.transaction do # processing order in transaction
        
        order.save!
        
        # Save this order's agreement log
        unless session[:agreement_log].blank?
          session[:agreement_log].order = order
          session[:agreement_log].save
        end
        
        clear_cart_and_order
        redirect_to_ssl :action => 'receipt', :id => order.order_number
        
        # Send receipt mail: (Rush Order:) Thank you for your order! (\##{order.order_number})
        OrdersMailer.deliver_receipt(order)
        # Send the mail to ryan and brent
        OrdersMailer.deliver_panavision_order(order_user.name, order_user.company, order.order_number) if is_panavision_order?(last_name, order_user.company, order_user.email_address)
        
      end # end of transaction
      
      system("/usr/bin/ruby #{RAILS_ROOT}/script/erp_process_order #{ENV['RAILS_ENV']} #{order.order_number} >/dev/null 2>&1 </dev/null &") unless is_fraud?
      #system("/usr/bin/ruby #{RAILS_ROOT}/script/erp_process_order #{ENV['RAILS_ENV']} #{order.order_number} &")
      
    rescue Exception => exc 
      flash[:notice] = "Error processing order. Please <a href='/contactus.htm'>Contact Us</a> to report this problem and complete your order"
      logger.error("Error processing order #{exc}")
      
      # Catch any bugs?
      mail = Red::SystemNotify.create_exception_notify( exc, self )
      mail.subject = "[STORE DEBUGGER] " + mail.subject
      Red::SystemNotify.deliver(mail)
    end
  end
  
  # Clears the cart and possibly destroys the order
  # Called when the user wants to start over, or when the order is completed.
  def clear_cart_and_order(destroy_order = true)
    @cart = find_cart.empty!
    if session[:order_id] then
      @order = Order.find(session[:order_id])
      if destroy_order then
        @order.destroy
      end
      session[:order_id] = nil
    end
    #========================================
    # Cleanup session after 'place_order'
    #========================================
    session[:store_user_id]  = nil
    session[:payment_uuid]   = nil
    session[:safe_cc_number] = nil
    session[:aes_cc_number]  = nil
    session[:aes_credit_ccv] = nil
    session[:agreement_log]  = nil
  end
  
  def receipt
    begin
      @order = Order.find_by_order_number(params[:id])
      # invoke Order's class method order_summary for compute order summary
      @order_summary = @order.order_summary
      render :layout => false
    rescue Exception => ex
      render :text => ex.backtrace
    end
  end
  
  def find_reservation
    @title = "Find my reservation"
    flash[:notice] = "<br><br><strong>UNDER CONSTRUCTION:</strong> (Find my reservation)<br><br>This page will allow existing reservation holders to securely add ALL of their prior reservations to a single Sales Order.<br><br>This page should be ready for testing tomorrow.<br><br><strong>Please click below to close this notice.</strong>"
  end
  
  # Shows products by tag or tags.
  # Tags are passed in as id #'s separated by commas.
  def tags
    @tag_name = params[:tags].blank? ? params[:id] : params[:tags].last.split("_").join(" ")
    @page_title = "RED STORE / #{@tag_name}"
    @cart = find_cart
    
    @tag = Tag.find_by_name "lenses"
    # @tag  = @tag = Tag.find_by_name ('Batteries+%26+Power')
    
    raise ::ActionController::RoutingError, request.request_uri if @tag.nil?
    # @tag = Tag.find_by_name 'Lenses'
    # @products = @tag.products
    begin
      @products = @tag.products.select{|product| !product.code.blank? }.sort_by{|product| product.product_sort_id.to_i }
      rescue
      @products = @tag.products.select{|product| !product.code.blank? }
    end
    # tags_ids_array = tags.is_a?(Array) ? tags.collect{ |tag| tag.id } : [tags.id]
     # @products = Product.find :all, :include => 'tags', :conditions => ['tags.name = ?', 'Lenses']
  end

  # This is a component...
  # Displays a fragment of HTML that shows a product, desc, and "buy now" link
  def display_product
    if params[:id]
      @cart = find_cart
      @product = Product.find(:first, :conditions => ["id = ?", params[:id]])
      if (@product.images[0]) then
        @image = @product.images[0]
      else
        @image = nil
      end
      render :layout => false
    else
      redirect_to :action => 'index'
    end
  end
  
  # Display detailed information of this product.
  # Products without an code are not available in this page (but still exists
  # in database).
  def product_detail
    @cart = find_cart
    @product = Product.find(
      :first,
      :conditions => ["code <> '' and (erp_product_item = :id OR id = :id)", {:id => params[:id]}]
    )
    
    if @product.nil?
      redirect_to :action => 'index'
      return
    end
    
    # 16GB CF Card with RED Caps
    # 502006SM: 16 CF + Cap Size SM
    # 502006XL: 16 CF + Cap Size L/XL
    if @product.erp_product_item == '502006'
      @customized_template = '16gb_cf_with_cap'
    end
    
    @tag_name = @product.tags.first.name unless @product.tags.empty?
    @page_title = "RED STORE / #{@product.name}"
    @image = @product.images[0]
  end
  
  # Adds an item to the cart, then redirects to checkout
  #
  # This is the old way of doing things before the AJAX cart.
  #
  # Left in if someone would like to use it instead.
  def add_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.add_product(product)
    # In substruct.rb
    redirect_to get_link_to_checkout
  rescue
    logger.error("[ERROR] - Can't find product for id: #{params[:id]}")
    redirect_to_index("Sorry, you tried to buy a product that we don't carry any longer.")
  end
  #weston add for selectcamera
  def add_to_carts
    checked = params['redonecart']
    #checked=array.new
    # checked=["5", "6", "7"]
    #puts @checked.to_json
    for  id in checked do
      product = Product.find(id)
      @cart = find_cart
      @cart.add_products(product)
      # In substruct.rb
      #redirect_to :action => 'buildredone'
      #  rescue
      logger.error("[ERROR] - Can't find product for id: #{id}")
    end
    redirect_to :action => 'buildredone'
  end
  
  # Adds an item to our cart via AJAX
  # Returns the cart HTML as a partial to update the view in JS
  def add_to_cart_ajax
    unless request.xhr?
      render :text => '<p><strong>JavaScript</strong> must be enabled in order for you to finish you shopping.<br/>However, it seems JavaScript is either disable or not supported by your browser.<br/>To use enable JavaScript by changing your browser options, then <a href="/store">try again</a></p>'
      return
    end
    
    # get product object from params
    case
    when params['code']
      product = Product.find_by_code(params['code'])
    when params['product_type'] == 't_shirt'
      product = Product.find_t_shirt(params[:sex], params[:color], params[:size])
    else
      product = Product.find(params['id'])
    end
    
    # get quantity from params
    quantity = (params['qty'] || 1).to_i

    # get payment method from request params
    # payment type should be: 'deposit' or 'buy_now'
    payment_method = (params[:payment_method] == 'buy_now') ? 'buy_now' : 'deposit'
    if payment_method == 'buy_now'
      # detect if product accept buy_now or not
      if product.accept_buy_now
        # detect if product has buy now required
        if product.buy_now_require_redone
          # detect if store user has already login and not has redone shipped
          store_user = StoreUser.find_by_id(session[:store_user_id])
          if store_user && !store_user.has_already_received_redone? && !store_user.purchased
            flash.now[:notice] = "<p>Unfortunately we were unable to locate RED ONE delivery information for your account. To make best use of available inventory, immediate delivery is only available to clients who have already taken delivery of RED ONE. If you have already taken delivery of RED ONE please use the <a href='http://red.com/contact_us'>Contact Us</a> form to correct this issue.</p><p><br/>The \"BUY NOW\" items on your order have been converted to \"DEPOSIT\" items.</p>"
            payment_method = 'deposit'
          end
        end
      else
        payment_method == 'deposit'
      end
    end
    
    # add product to cart
      if ERP::Item.find_by_item_id(product.erp_product_item).dangerous 
        flash.now[:notice] = 
        "<p><img src='/images/miscellaneous.jpg' width=110 height=110 align='left' style='margin:0 15px;'>
        Please note that as of January 1, 2009, lithium ion batteries over  
        100Wh are classified as Class 9 Dangerous Goods. RED BRICK batteries  
        are 140Wh and therefore fall into this category. RED must comply with  
        the applicable US domestic and international rules and regulations  
        pertaining to documentation, shipping, and handling procedures. Since  
        there is a Dangerous Goods surcharge for lithium ion batteries added  
        onto the normal cost of shipping, RED will be adding a RED BRICK  
        shipping and handling surcharge on orders including RED BRICKS.</p>
        
        <p>
        In addition, some countries will not accept any Dangerous Goods  
        shipments with FedEx as the carrier (see <a href='http://fedex.com/us/dangerousgoods/'>Dangerous Goods Countries</a> 
        for country list). For these countries, RED will have to engage the  
        services of a different class of shipper (eg, a freight forwarder). If  
        RED cannot use FedEx, please note that there will be increased  
        shipping and handling charges as well as additional processing time to  
        arrange for alternate shipping options.
        </p>

        <p>Unless you have been certified to ship dangerous goods, you must work  
        with a Dangerous Goods, Class 9-certified shipper to assist you with a  
        shipment that includes RED BRICKS (or other regulated lithium ion  
        batteries). Please note that applicable laws prohibit the shipping of  
        batteries that are physically damaged. We urge you to look into the  
        formal rules and regulations of shipping Class 9 Dangerous Goods prior  
        to preparing your shipment. For more information on these regulations,  
        please visit <a href='http://www.iata.org'>www.iata.org</a> and 
        <a href='http://www.dot.gov'>www.dot.gov</a></p>
        "
      end
    
    @cart = find_cart
    @cart.add_product(product, quantity, payment_method)
    
    render :partial => 'cart'
  rescue => e
    render :text => "There was a problem adding that item. Please refresh this page."
  end
  
  def update_to_cart_ajax
    unless request.xhr?
      render :text => '<p><strong>JavaScript</strong> must be enabled in order for you to finish you shopping.<br/>However, it seems JavaScript is either disable or not supported by your browser.<br/>To use enable JavaScript by changing your browser options, then <a href="/store">try again</a></p>'
      return
    end

    # construct new items data by parse params[:items]
    # params[:items] might be like this:
    #   {"35,buy_now"=>"3", "35,deposit"=>"4"}      
    # the pattern of params[:items] is:
    #   {"id,payment_method" => "quantity"}
    # the contruct of parse result should be:
    #   {:id => id, :payment_method => payment_method, :quantity => quantity}
    new_items = params[:items].map {|k,v| {:id => k.split(',').first.to_i, :payment_method => k.split(',').last, :quantity => v.to_i} }

    @cart = find_cart
    @cart.items.each do |item|
      new_item = new_items.find {|i| i[:id] == item.product_id && i[:payment_method] == item.payment_method }
      if new_item
        product = item.product
        if item.quantity > new_item[:quantity]
          @cart.remove_product(product, item.quantity - new_item[:quantity], item.payment_method)
        elsif item.quantity < new_item[:quantity]
          @cart.add_product(product, new_item[:quantity] - item.quantity, item.payment_method)
        end
      end
    end

    render :partial => 'cart'
  end

  # Removes one item via AJAX
  # Returns the cart HTML as a partial to update the view in JS
=begin
  def remove_from_cart_ajax
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.remove_product(product)
    render :partial => 'cart'
  rescue
    render :text => "There was a problem removing that item. Please refresh this page."
  end
=end
  #weston add for buildredone
  # Returns the cart HTML as a partial to update the view in JS
  def remove_from_minicart_ajax
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.remove_product_mini(product)
    render :partial => 'minicart'
  rescue
    render :text => "There was a problem removing that item. Please refresh this page."
  end
  # Removes one item via AJAX
  #
  # Returns the cart HTML as a partial to update the view in JS
  def remove_from_cart_ajax
    unless request.xhr?
      render :text => '<p><strong>JavaScript</strong> must be enabled in order for you to finish you shopping.<br/>However, it seems JavaScript is either disable or not supported by your browser.<br/>To use enable JavaScript by changing your browser options, then <a href="/store">try again</a></p>'
      return
    end

    # product = Product.find(params[:id])
    # qty =params[:qty].to_i
    # @cart = find_cart
    # @cart.remove_product(product,qty)
    product = Product.find(params[:id])
    quantity = params[:qty].to_i # must convert to integer...
    payment_method = params[:payment_method]
    @cart = find_cart
    @cart.remove_product(product, quantity, payment_method)
    render :partial => 'cart'
  rescue
    render :text => "There was a problem removing that item. Please refresh this page."
  end
  
  def remove_from_cart
    product = Product.find(params[:id])
    quantity = params[:qty].to_i # must convert to integer...
    payment_method = params[:payment_method]
    @cart = find_cart
    @cart.remove_product(product, quantity, payment_method)
    if @cart.empty?
      redirect_to_index("All items have been removed from your order.")
    else
      render :action => 'confirm'
    end
  rescue
    logger.error("[ERROR] - There was a problem removing that item: #{params[:id]}")
    redirect_to :action => 'confirm'
  end
  
  # Empties the entire cart via ajax...
  #
  # Again, returns cart HTML via partial
  def empty_cart_ajax
    clear_cart_and_order
    render :partial => 'cart'
  end
  
  # Empties the cart out and redirects to index.
  # Removes any order saved to the DB if there is such a thing.
  #
  # The old (non-ajax) way of doing things
  def empty_cart
    clear_cart_and_order
    redirect_to_index("All items have been removed from your order.")
  end
  
  # Gathers customer information.
  # Displays form fields for grabbing name/addy/credit info
  #
  # Also displays items in the current order
=begin
  def checkout
    @title = "Checkout"
    @cart = find_cart
    @items = @cart.items
    @order = find_order
    if @order == nil then
      # Save standard form info
      initialize_new_order
    else
      initialize_existing_order
    end
    session[:order] = @order

    unless cookies[:cookies_key]
      cookies[:cookies_key] = CreditCard.cookies_key(request)
    end

    if @items.empty?
      redirect_to_index("You've not chosen to buy any items yet. Please select an item from this page.")
    elsif request.post?
      store_user = StoreUser.find_by_email_address_and_password(params[:login], params[:password])
      if store_user
        session[:store_user_id] = store_user.id
        if !store_user.ship_to_address
          redirect_to_ssl :action => 'ship_to'
        elsif !store_user.ship_to_address || !store_user.bill_to_address
          redirect_to_ssl :action => 'bill_to'
        elsif store_user.order_account.payment_type == 1
          flash[:notice] = "NOTE: RED requires one payment per order. If you choose Wire Transfer, you'll have to place a separate Wire Transfer for this payment."
          redirect_to_ssl :action => 'bill_to'
        else
          redirect_to_ssl :action => 'confirm'
        end 
      else
        flash[:notice] = "Invalid username or password. If you need to reset your password please contact customer service. Thank you."
      end
    end
  end
=end
  #        if account.order_addresses.empty? or account.order_addresses.find(:first, :conditions => "is_shipping = '1'").nil?
  #          flash[:notice] = 'No Addresses on file...'
  #          redirect_to :action => 'ship_to' and return
  #        else
  #          session[:ship_to] = account.order_addresses.find(:first, :conditions => "is_shipping = '1'")
  #        end
  #        if account.order_account.nil?
  #          flash[:notice] = 'No Payment Information on file'
  #          redirect_to :action => 'bill_to' and return
  #        else
  #          session[:payment] = account.order_account
  #          session[:bill_to] = account.order_addresses.find(:first, :conditions => "is_shipping = '0'")
  #          redirect_to :action => 'confirm' and return
  #        end
  
  # Execution action of checkout (above)
  #
  # Tries to create an order. If it cant, returns to the page and shows errors.
  
  # Checks shipping price of items
  # Used with live rate calculation
  # Lets customer choose what method to use
  def select_shipping_method
    @title = "Select Your Shipping Method - Step 2 of 2"
    @order = find_order
    if @order == nil then
      redirect_to_checkout("Have you entered all of this information yet?") and return
    end
    @items = @order.order_line_items
    session[:order_shipping_types] = @order.get_shipping_prices
    # Set default price to pick what radio button should be entered
    @default_price = session[:order_shipping_types][0].id
  end
  
  # For flat rate calculation.
  # The customer just looks at how much it's going to cost to ship
  # We also set shipping cost here as well.
  def view_shipping_method
    @title = "Shipping Costs - Step 2 of 2"
    @order = find_order
    if @order == nil then
      redirect_to_checkout("Have you entered all of this information yet?") and return
    end
    # Setting this to a non-existent shipping type id
    # Not sure if this is the smartest thing to do - or if we should load
    # one into the authority data...
    ship_id = 0
    ship_price = @order.get_flat_shipping_price
    @order.order_shipping_type_id = ship_id
    @order.shipping_cost = ship_price
    @order.save
    @items = @order.order_line_items
    @shipping_price = @order.get_flat_shipping_price
  end
  
  # Execution action of select_shipping_method (above)
  # OR called when setting shipping method using a flat calculation...
  #
  # Saves shipping method, redirects to finish order
  def set_shipping_method
    @order = find_order
    ship_id = params[:ship_type_id]
    # Convert to integers for comparison purposes!
    ship_type = session[:order_shipping_types].find { |type| type.id.to_i == ship_id.to_i }
    ship_price = ship_type.price
    @order.order_shipping_type_id = ship_id
    @order.shipping_cost = ship_price
    @order.save
    redirect_to_ssl :action => 'finish_order'
  end
  
  # Finishes the order
  #
  # Submits order info to Authorize.net
  def finish_order
    @title = "Thanks for your order!"
    @order = find_order
    # If there's no order redirect to index
    if @order == nil
      redirect_to_index and return
    end
    transaction = @order.get_auth_transaction
    begin
      transaction.submit
      @payment_message = "Card processed successfully: #{transaction.authorization}"
      # Save transaction id for later
      @order.auth_transaction_id = transaction.transaction_id
      logger.info("\n\nORDER TRANSACTION ID - #{transaction.transaction_id}\n\n")
      # Set completed
      @order.cleanup_successful
      # Send success message
      @order.deliver_receipt
      clear_cart_and_order(false)
    rescue
      # Order failed - store transaction id
      @order.auth_transaction_id = transaction.transaction_id
      @order.cleanup_failed(transaction.error_message)
      # Send failed message
      @order.deliver_failed
      # Log errors
      logger.error("\n\n[ERROR] FAILED ORDER \n")
      logger.error(transaction.inspect)
      logger.error("\n\n")
      # Redirect to checkout and allow them to enter info again.
      error_message = "Sorry, but your transaction didn't go through.<br/>"
      error_message << "#{transaction.error_message}<br/>"
      error_message << "Please try again or contact us."
      redirect_to_checkout(error_message)
    end
  end
  
  # Build Your RED ONE!
  # Display all available nodes of product package.
  def build_your_red_one
    # Initialize Shopping Cart
    @cart = find_cart
    
    # Add selected products (with quantity) to user's shopping cart
    #   and then redirect to the index page of RED Store.
    if request.post?
      select_products = params[:selected].delete_if { |key, value| value.to_i.zero? || value.blank? }
      products = Product.find select_products.keys
      
      select_products.each do |id, qty|
        product = products.find{|product| product.id == id.to_i }
        @cart.add_product product, qty.to_i
      end
      
      # Contains a RED ONE Body
      @cart.add_product Product.find_by_code('101001'), 1
      
      redirect_to :controller => 'store'
      return
    end

    @page_title = "Build your RED ONE&trade;"
    
    # Apply configuration settings as default vaue
    unless params[:configuration_id].nil?
      configuration = ExampleConfiguration.find params[:configuration_id], :include => :example_configuration_products
      @configuration_quantity = configuration.example_configuration_products.group_by { |configuration| configuration.product_id }
    end
    
    @packages = ProductPackage.find :all, :conditions => "parent_id IS NULL"
    @red_one = Product.find_by_code "101001"
    render :layout => "white"
  end
  
  private
  #========================================================
  # avoid customer finish order and click 'goback' and
  # click 'continue' on browser cause 'NilClass' error.
  #========================================================
  before_filter :login_require, :only => [:ship_to, :ship_to_edit, :bill_to, :confirm, :terms]
  def login_require
    if session[:store_user_id].blank?
      redirect_to_ssl :action => 'checkout'
      return false
    end
  end

  #========================================================
  # Force set store controller language to 'en_US'
  #========================================================
  before_filter { |c| c.send :set_locale, 'en_US' }

  # Finds or creates a cart
  def find_cart
    session[:cart] ||= Cart.new
  end
  # Finds an order
  def find_order
    Order.find(session[:order_id])
  rescue
    return nil
  end
  #def find_payment_uuid
  #  session[:payment_uuid] ||= UUID.random_create.to_s
  #end
  
  def do_checkout
    @title = "Ooops, did you forget to fill something in?"
    @cart = find_cart
    @items = @cart.items
    @order = find_order
    # We might be re-doing an existing order.
    # Don't want to create a new order for failed transactions, sooo
    if @order == nil then
      logger.info("\n\n\nCREATING NEW ORDER FROM POST\n\n\n")
      logger.info(params[:use_separate_shipping_address])
      logger.info("\n\n\n")
      create_order_from_post
    else
      logger.info("\n\n\nUPDATING EXISTING ORDER FROM POST\n\n\n")
      update_order_from_post
    end
    # Add cart items to order
    @order.order_line_items = @items
    @order.save
    # Save the order id to the session so we can find it later
    session[:order_id] = @order.id
    # All went well?
    logger.info("\n\nTRYING TO REDIRECT...")
    if (Substruct.config(:use_live_rate_calculation) == true) then
      logger.info("\n\nRedirecting to select_shipping_method\n")
      redirect_to_ssl :action => 'select_shipping_method'
    else
      logger.info("\n\nRedirecting to view_shipping_method\n")
      redirect_to_ssl :action => 'view_shipping_method'
    end
    #
  rescue
    logger.error("\n\nSomething went bad when trying to checkout...\n#{$!}\n\n")
    flash.now[:notice] = 'There were some problems with the information you entered.<br/><br/>Please look at the fields below.'
    render :action => 'checkout'
  end
  
  # Redirects to index with a message
  def redirect_to_index(msg = nil)
    flash[:notice] = msg
    redirect_to :action => 'index'
  end
  # Redirects to checkout with a message
  def redirect_to_checkout(msg = nil)
    flash[:notice] = msg
    redirect_to :action => 'checkout'
  end
  
  
  def viaklix(amount, card, exp, cvv2, address, zip, test)
    http = Net::HTTP.new('www.viaklix.com', 443)
    http.use_ssl = truew
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    path = "/process.asp"
    user_agent = "RubyViaKlix/1.0" #Sometimes there is trouble without a user agent defined
    data = "ssl_test_mode=#{test}&" +
      "ssl_amount=#{amount}&ssl_merchant_id=408748&ssl_user_id=website&" +
      "ssl_show_form=false&ssl_pin=SB1TQR&ssl_card_number=#{card}&" +
      "ssl_exp_date=#{exp}&ssl_customer_code=1&ssl_result_format=ASCII&" +
      "ssl_salestax=0&ssl_cvv2=#{cvv2}&ssl_avs_address=#{address}&ssl_avs_zip=#{zip}"
    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Referer' => 'https://www.red.com',
      'User-Agent' => 'Red_Digital_Cinema/1.0'
    }
    
    response = http.post2(path, data, headers)
    rows = response.body.split("\r\n")
    data = {}
    rows.each do |r|
      key_val = r.split("=")
      data[key_val[0]] = key_val[1]
    end
    return data
  end

  #Check the froud countries
  def is_fraud?
    ip = request.remote_ip
    # ip = '193.194.185.25'
    countries = ['GHANA']
    address = Ip2address.find_location_by_ip(ip)
    
    if address && countries.include?( address.countryLONG )
      return true
    else
      return false
    end
  end
  
  #Check panavision order
  def is_panavision_order?(last_name, company, email)
    users = ['panavision', 'karahadian', 'plus8digital']
    return true if !last_name.blank? && users.include?( last_name.gsub(' ', '').downcase )
    return true if !company.blank? && users.include?( company.gsub(' ', '').downcase )
    return true if !email.blank? && users.include?( email.split('@').last.gsub(/\./, '') )
  rescue => exception
    exception.message << "\n" << [last_name, company, email].collect{|v| v.inspect}.join("\n")
    mail = Red::SystemNotify.create_exception_notify( exception, self )
    mail.subject = "[STORE DEBUGGER] " + mail.subject
    Red::SystemNotify.deliver(mail)
    return false
  end
  
  
  def before_show_by_tags
    if action_name == 'show_by_tags'
      redirect_to :action => 'tags', :tags => params[:tags], :id => params[:id]
    end
  end

  private
  
  # Detect user's country and save into cookies.
  def detect_country
    return cookies[:country] unless cookies[:country].blank?
    
    location = Ip2address.find_location_by_ip(request.remote_ip)
    if location
      cookies[:country] = location.countrySHORT
      return location.countrySHORT
    end
  end
  
  def in_china?(short_country_name)
    return %w{CN TW HK MO}.include?(short_country_name)
  end

end
