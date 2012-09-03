module MyAccountHelper
  
  # Display name of product in sales line following:
  # * Append RED ONE Serial Number behind product name if item id is 101001
  # * If product exists in products table, generate a link to product's detail page
  # * Refere to erp inventories if item does not exists in products table
  def sales_line_product_tag( line )
    product = line.product || ERP::Item.find_by_item_id( line.item_id )
    unless product.nil?
      product_name = product.name
      product_name << " (\##{line.sales_item_reservation_number})" if line.item_id == '101001'

      if product.is_a?( Product )
        return link_to(
        product_name,
        { :controller => "store", :action => "product_detail", :id => product.id },
        :target => "_blank"
        )
      else
        return product_name
      end
    end
  end

  # Generate a link in categories list.
  # If current page equals the link, append a style named "current"
  #   on this element.
  def category_link(name, options={}, html_options={})
    html_options.merge! :class => "current" if current_action?(options)
    link_to name, options, html_options
  end
  
  # Show validation error
  def error_field(object, method, class_name = "error")
    msg = object.errors.on(method) unless object.nil?
    return if msg.nil?
    
    "<span class=\"error\">#{msg}</span>"
  end
  
  # Return the modified date of this sales order.
  def modified_date(order)
    if order.synchronized?
      return parse_date(order.erp_modstamp)
    else
      return parse_date(order.updated_at)
      # return link_to(parse_date(order.updated_at), { :action => "commit_order", :id => order }, :class => "modified_date", :title => "This order has been changed. Click this link to commit.")
    end
  end
  
  def parse_date(datetime)
    return datetime.strftime('%Y/%m/%d') unless datetime.blank?
    return ""
  end
  
  # Addresses Selector for editing open order
  def customer_addresses_select( customer, html_options={} )
    options = ["<option></option>"]
    customer.addresses.each do |address|
      address_name = address.handle.blank? ? "<address error>" : address.handle
      options << "<optgroup label=\"#{h address_name}\" /><option value=\"#{address.id}\">#{h address.full_address}</option>"
    end
    
    return select_tag( "select_address", options.join, { :class => "addresses_selector" }.merge(html_options) )
  end
  
  # Country Selector with Region ID as value.
  # Set "United States of America" as the default value.
  def country_select_tag( name, selected_region_id, html_options={} )
    mapping = [['', '']] + COUNTRIES_MAPPING
    options = options_for_select(mapping, (selected_region_id))
    select_tag( name, options, html_options )
  end
  
  # Render notice box if flash[:message] is not blank
  def flash_notice_tag
    return if flash[:message].blank?
    
    "<div class=\"notice\"><h3>Message</h3><p>#{flash[:message]}</p></div>"
  end
  
  private
  def current_action?(options)
    return true if params[:action] == options[:action]
  end
end