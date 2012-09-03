class MyAccountController < ApplicationController
  layout 'application'
  
  # User authentication is required.
  before_filter :user_authentication, :init_user, :except => [:sign_in]
  before_filter :access_only_for_ajax, :only => [:move_sales_line]
  
  # Lock Protection for updating orders
  before_filter :refresh_lock_version, :only => [:open_orders]
  before_filter :valid_lock_version, :only => [:delete_sales_line, :move_sales_line, :update_sales_line_qty, :update_order_address]
  
  # Synchronize customer's account after user logged in.
  after_filter :synchronize_customer_account, :only => :sign_in
  
  # Delegate: account/login
  def sign_in
    flash[:login_mode] = 'all'
    flash[:login_delegate] = { :controller => "my_account", :action => "sign_in" }

    redirect_to( :controller => "account", :action => "login" ) && return if request.get?
    
    @user = StoreUser.find_by_email_address_and_password( params[:email_address], params[:password] )
    if @user.blank?
      flash[:message] = "Invalid email address or password"
      redirect_to :controller => "account", :action => "login"
    else
      @user.remote_ip = request.remote_ip
      @user.remote_location = Ip2address.find_location(request.remote_ip)
      @user.user_agent = request.user_agent.downcase
      session[:web_user] = @user
      redirect_to :action => "index"
    end
  end
    
  # List the sales orders under this account
  def index
    @sales_orders = @customer.sales_orders
  end
  
  # Undo all changes
  def undo_changes
    if @customer.undo_changes
      flash[:message] = "Changes have been undones."
    else
      flash[:message] = "Unable to undo changes. Please try again. Contact us if the problem persists."
    end
    
    redirect_to :action => "index"
  end
  
  # Contact people under current account.
  def contacts
    @contact = @customer.contact_people.find_by_id params[:id]
    
    # Delete contact
    if @contact && params[:method] == "delete"
      @store_user.my_account_log(@contact,"Delete Contact #{@contact.name}")
      @contact.destroy
      @customer.update_ax( :contacts => [@contact] )
      redirect_to :id => nil
    end
    
    # Add or update contact
    if request.post? && params[:contact]
      @contact ||= @customer.contact_people.build
      @contact.attributes = params[:contact]
      if @contact.save
        redirect_to :id => nil
      else
        @customer.contact_people.delete @contact
        render
      end
      
      # Synchronize customer
      @customer.update_ax( :contacts => [@contact] ) if @contact.errors.empty?
      @store_user.my_account_log(@contact,"Add or Update Contact #{@contact.name}")
    end
  end
  
  # Contact profile
  # Only "Email" of customer account(AX.Customer) is changeable.
  def profile
    if request.post?
      @customer.update_attributes :email => params[:customer][:email], :phone => params[:customer][:phone]
      @store_user.my_account_log(@customer,"Update Profile Email: #{@customer.email} Phone: #{@customer.phone}")
      @customer.update_ax
    end
  end
  
  # Change Password
  def change_password
    if request.post?
      @store_user = StoreUser.find_by_id session[:web_user].id
      @store_user.my_account_log(@customer,"Update Password: #{@customer.email}")
      if @store_user.change_password params[:password], params[:user]
        flash.now[:message] = "Your password has been changed!"
      end
    end
  end
  
  # Address Book
  def address_book
    @address = @customer.addresses.find_by_id params[:id]
    
    # Delete selected address
    if params[:method] == "delete"
      @store_user.my_account_log(@address,"Deleted Address: #{@address.handle}")
      @address.destroy
      redirect_to :id => nil
      @customer.update_ax( :addresses => [@address] )
    end
    
    # Add or update address
    if request.post?
      @address ||= @customer.addresses.build
      @address.attributes = params[:address]
      
      if @address.save
        redirect_to :id => nil
        @store_user.my_account_log(@address,"Add or Update Address: #{@address.handle}")
        @customer.update_ax( :addresses => [@address] ) if @address.errors.empty?
      else
        render
      end
    end
  end
  
  # Order History
  # TODO:
  #   Find out the completed orders of current customer account.
  def order_history
    @orders = @customer.close_orders
  end
  
  # Open Orders
  # TODO:
  #   Find out the processing orders of current customer account.
  def open_orders
    # store_user = StoreUser.find_by_erp_account_number "CU 0101388"
    # store_user.order_users.find(:first).orders.find(:first)
    # ERP::ThreadPool.new(@options[:threads], time_blocks).start do |pair|
    #  sleep(1 * rand)
    #  result = search_by_modified_date( pair.first, pair.last )
    #   nodes.concat result unless result.empty?
    # end
    store_user = session[:web_user]
    web_orders = Order.find_by_store_user_id(store_user.id)
    sales_ids = @customer.sales_orders.collect{|sales_order| sales_order.sales_id}
    web_orders.delete_if { |web_order| sales_ids.include?(web_order.erp_order_number) }
    # raise web_orders.to_yaml
    @orders = @customer.open_orders
    web_orders.each do |web_order|
      virtual_order = ERP::SalesOrder.new(
        :sales_status         => "Invoice",
        :document_status      => "Invoice",
        :shipping_charges     => web_order.shipping_cost,
        :sales_tax            => web_order.tax,
        :synchronized         => true,
        :purch_order_form_num => web_order.order_number,
        :delivery_mode_id     => 0,
        :completed            => true,
        :erp_modstamp         => web_order.created_on
      )
      
      web_order.order_line_items.each do |line|
        virtual_order.sales_lines.build(
          :sales_order => virtual_order,
          :item_id => line.product.erp_product_item,
          :sales_qty => line.quantity,
          :status => "Downloading",
          :remain_sales_physical => 0,
          :sales_price => line.product.price,
          :line_amount => line.quantity * line.product.price
        )
      end
      
      web_ship_to = web_order.order_user.order_addresses.find_by_is_shipping(true)
      virtual_order.ship_to_address = ERP::DeliveryAddress.new(
        :name => web_ship_to.company,
        :street => web_ship_to.address,
        :address => "#{web_ship_to.address}\n#{web_ship_to.city}, #{web_ship_to.state} #{web_ship_to.zip}\n#{web_ship_to.country.fedex_code}",
        :city => web_ship_to.city,
        :state => web_ship_to.state,
        :zip_code => web_ship_to.zip,
        :country_region_id => web_ship_to.country.fedex_code
      )
      web_bill_to = web_order.order_user.order_addresses.find_by_is_shipping(false)
      virtual_order.bill_to_address = ERP::InvoiceAddress.new(
        :name => web_bill_to.company,
        :street => web_bill_to.address,
        :address => "#{web_bill_to.address}\n#{web_bill_to.city}, #{web_bill_to.state} #{web_bill_to.zip}\n#{web_bill_to.country.fedex_code}",
        :city => web_bill_to.city,
        :state => web_bill_to.state,
        :zip_code => web_bill_to.zip,
        :country_region_id => web_bill_to.country.fedex_code
      )
      @orders.unshift(virtual_order)
    end
  end
  
  # Delete sales line of an open order via given id
  def delete_sales_line
    sales_line = ERP::SalesLine.find( params[:id], :include => "sales_order" )
    @store_user.my_account_log(sales_line,"Delete Sales Line: #{sales_line.invent_trans_id} (#{sales_line.item_id})")
    if @customer.open_orders.collect{|order| order.id}.include?( sales_line.sales_order.id ) && sales_line.modifiable?
      sales_line.destroy
      render :text => "Deleted..."
    else
      render :text => "Failed to delete sales line (ID=#{params[:id]})", :status => 500
    end
  end
  
  # Update product quantity of sales line with given id
  def update_sales_line_qty
    sales_line = ERP::SalesLine.find params[:id]
    result = sales_line.update_sales_qty( params[:value].to_i )
    @store_user.my_account_log(sales_line,"Update Sales Line Qty: #{sales_line.invent_trans_id} (#{sales_line.item_id}), returns #{result}")
    render :text => result
  end
  
  def update_order_address
    @address = ERP::Address.find params[:id]
    @store_user.my_account_log(@address,"Update Order Address: #{@address.handle}")
    @address.attributes = params[:address]
    @address.save
    render :partial => "edit_order_address", :locals => { :address => @address }
  end
  
  # Set default address
  def set_default_address
    if request.post?
      @store_user.my_account_log(@customer,"Update Default Address: Ship To #{params[:ship_to_id]} Bill To #{params[:bill_to_id]}")
      @customer.update_attributes :ship_to_id => params[:ship_to_id], :bill_to_id => params[:bill_to_id]
      redirect_to :action => "address_book"
    end
  end
  
  # Refresh Order
  def refresh_order
  	order = ERP::SalesOrder.find params[:id]
  	render :partial => "open_order", :object => order
  end
  
  # Move sales line with given id to another open order
  def move_sales_line
=begin
    sales_line = ERP::SalesLine.find params[:id]
    @original_order_id = sales_line.erp_sales_order_id
    sales_line.update_attribute :erp_sales_order_id, params[:target]
    
    mark_as_unsync [@original_order_id, params[:target]]
=end
    @sales_line = ERP::SalesLine.find params[:id]
    @store_user.my_account_log(@sales_line,"Move Sales Line #{@sales_line.invent_trans_id} From #{@sales_line.sales_order.sales_id}")
    if @sales_line && @sales_line.sales_order.erp_customer_id == @customer.id
      @sales_line.move_to_order @customer.sales_orders.find( params[:target] )
    end
  end
  
  # Commit changes of sales order with given id to AX server.
  def commit_order
    order = @customer.open_orders.find params[:id]
    
    unless !order.commit
      headers['Content-Type'] = 'text/plain'
      render :text => "Failed to connect with AX server."
    end
  end
  
  # Commit all changed orders under customer's account
  def commit_orders
    orders = @customer.open_orders.find_all_by_synchronized( false )
    sales_id = ""
    orders.each do |o| sales_id += "'#{o.sales_id}', " end    
    @store_user.my_account_log(@customer,"Commit Sales Order Updates: #{sales_id}")

    if orders.empty? || ERP::SalesOrder.commit_orders( orders )
      flash.now[:message] = "All changes have been commited."
    else
      flash.now[:message] = "Operation Failed."
    end
  end
  
  # Return address's JSON for filling address form in "MyAccount / OpenOrders"
  #   (while editing a billing / shipping address)
  def get_address_json
    address = @customer.addresses.find( params[:id] )
    render :text => address.attributes.to_json
  end
  
  # Update delivery mode id of sales order with given id
  def update_delivery_mode
    sales_order = @customer.open_orders.find_by_id( params[:id] )
    sales_order.delivery_mode_id = params[:delivery_mode_id]
    render :text => sales_order.save
  end
  
  private
  
  def user_authentication
    if session[:web_user].blank?
      sign_in
      return false
    end
  end
  
  # Initialize ERPCustomer and ERPContactPerson via logined user's email.
  def init_user
    #logger.info session.inspect
    @store_user = session[:web_user]
    @store_user.request_path = request.path + "?" + request.query_string
    @customer = ERP::Customer.find_by_account_num @store_user.erp_account_number
    
    if @customer.nil?
      render :partial => "unaccessible", :layout => false
      return false
    end
    
    @user = @customer.contact_people.find_by_email @store_user.email_address
    if @user.nil?
      @user = ERP::ContactPerson.new
      @user.attributes = {
        :erp_customer_id => @customer.id,
        :first_name => @store_user[:name],
        :last_name => @store_user[:name],
        :name => @store_user[:name],
        :email => @store_user[:email_address]
      }
    end
  end
  
  # Get specified contact person using given name.
  def get_contact
    @contact = @customer.contact_people.find_by_name params[:id]
  end
  
  # Access only for AJAX request.
  def access_only_for_ajax
    unless request.xhr?
      render :text => "Here is an Ajax Service, regular request without security token are denied."
      return false
    end
  end
  
  # Mark the sales order(s) with given id(s) as unsynchronized.
  # This method *MUST* be called after updating anything about these orders
  # ( ERPAddresses, SalesLines, etc. ).
  def mark_as_unsync(order_ids)
    order_ids = [order_ids] unless order_ids.is_a?(Array)
    @customer.sales_orders.update_all "synchronized = false", ["id in (?)", order_ids]
  end
  
  def refresh_lock_version
    session[:customer_lock_version] = @customer.erp_modstamp.to_i
  end
  
  def valid_lock_version
    puts "session lock: #{session[:customer_lock_version]}"
    puts "database lock: #{@customer.erp_modstamp.to_i}"
    if session[:customer_lock_version] != @customer.erp_modstamp.to_i
      render :action => "lock_version_error", :status => 500
      return false
    end
  end
  
  # After signed in My Account, start a backend process to synchronize customer's
  #   account including orders.
  # Note:
  #   Unsaved changes from last login are discarded.
  def synchronize_customer_account
    return false unless session[:web_user] && request.post?
    
    unless (cust_id = session[:web_user].erp_account_number).blank?
      customer = ERP::Customer.find_by_account_num(cust_id) ||
        ERP::Customer.new(:account_num => cust_id)
      customer.synchronize(true)
    end
  rescue
    return false
  end
end
