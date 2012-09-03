module StoreHelper
  def number_to_currency(number, options={})
    if ['index', 'build_your_red_one', 'tags'].include? @action_name.downcase
      precision = 0
    else
      precision = 2
    end
    
    super number, options.merge(:precision => precision)
  end
  
  # Tag helper to display an quantity selector in different styles (radio button, check box or dropdown list).
  # Invoke JavaScript function to update the page elements.
  def quantity_tag(item, html_options={})
  	additional_attributes = { :productId => item.product_id, :price => (item.is_a?(ProductPackageProduct) ? item.product.price : ""), :parent => "package_#{item.parent_id}" }
  	js_handle = "Cart.change(this);"
  	display_style = html_options.delete(:force) || item.display_style
  	
    case display_style
  	when "dropdown"
      dropdown_quantity_tag item, html_options.merge(additional_attributes).merge(:onchange => js_handle)
    when "checkbox"
      check_box_tag "selected[#{item.product_id}]", 1, !default_quantity(item).nil?, html_options.merge(additional_attributes).merge(:onclick => js_handle)
    when "radio"
    	if item.is_a?(ProductPackageProduct)
    		radio_button_tag "selected[#{item.product_id}]", 1, !default_quantity(item).nil?, html_options.merge(additional_attributes).merge(:onclick => "clickRadio(this);")
  		elsif item.is_a?(ProductPackage)
  			radio_button_tag "radio[#{item.parent_id}]", nil, false, html_options.merge(additional_attributes).merge(:name => "package_#{item.id}", :id => "radio_package_#{item.id}", :onclick => "clickRadio(this);")
			end
  	end
  end
  
  def dropdown_quantity_tag(item, html_options={})
    select_tag "selected[#{item.product_id}]", options_for_select((0..5).to_a, default_quantity(item)), html_options
  end
  
  private
  
  # Load default quantity from example configuration (if selected)
  # Note:
  #   Any advises to this problem? I do not think this is a nice method...
  def default_quantity(item)
    if @configuration_quantity.nil? || @configuration_quantity[item.product_id].nil?
      return nil
    else
      return @configuration_quantity[item.product_id].first.quantity
    end
  end
end
