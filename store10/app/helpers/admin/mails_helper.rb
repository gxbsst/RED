module Admin::MailsHelper
  
  # Link to template guide page
  def link_to_template_guide
    link_to "Need template guide?", { :action => "template_guide" }, :target => "_blank", :class => "info"
  end
  
  # Return a "select" tag contains all exsiting templates
  def templates_select_tag
    templates = MailTasks::Template.find( :all, :order => "name" )
    template_options = templates.collect{ |template| [template.name, template.id] }.unshift( ['-- Pre-set templates --', nil] )
    select :tasks, :template_id, template_options
  end
  
  # Format datetime in friendly style
  def friendly_time( time )
    return '-' if time.blank?
    
    if ( Time.now - time < 1.week )
      return time_ago_in_words( time ) + " ago"
    else
      return time.to_s( :short )
    end
  end
  
  def recipients_conditions_select_tag
    options = []
    MailTasks::RecipientsConditions.group_by_type.each do |type, patterns|
      options << content_tag(
        :optgroup,
        options_for_select(patterns.collect{ |pattern| [ pattern[:descript], pattern[:name] ] }),
        :label => type
      )
    end
    select_tag "conditions[][condition_name]", options.join
  end
  
  def recipients_conditions_product_select_tag
    products = Product.find( :all, :conditions => "erp_product_item <> ''", :order => "erp_product_item" )
    options = options_for_select( products.collect{|p| [p.name, p.erp_product_item]}.unshift(['', '']) )
    select_tag "conditions[][product_code]", options
  end
  
  def recipients_count_tag
    text = [0, "accounts,", @recipients.size, "recipients matched."]
    unless @recipients.empty?
      text[0] = @recipients.select{ |recipient|
        recipient.customer.account_num unless recipient.customer.nil?
      }.uniq.size
    end
    
    return text.join(" ")
  end
  
  # Link to send mail
  def send_mail_link( mail, html_options={} )
    text = mail.sent_at.blank? ? "Send Now" : friendly_time( mail.sent_at )
    link_to( text, { :action => "deliver", :id => mail.id }, html_options )
  end
  
  # Link to deliver all unsent mails
  def deliver_unsent_mails_tag( task )
    link_to(
      "Deliver Unsent Mails",
      { :action => "deliver_unsent_mails", :id => task.id },
      :confirm => "Click \"OK\" to deliver all mails."
    )
  end
  
  # Editing "From" of task
  # As default, a drop down list is provided which contains built-in set.
  # In addition to this, user can also switch to a text box to type customized address.
  BUILT_IN_FROM_ADDRESS = {
    "No-Reply <no-reply@red.com>" => "no-reply@red.com",
    "Order Service <orders@red.com>" => "orders@red.com",
    "Customer's BombSquad" => "BombSquad",
    "Customize Address" => "_customize_"
  }
  def mail_from_edit_tag( object_symbol, html_options={} )
    output = []
    
    # Drop down list
    output << select( object_symbol, :from,
      BUILT_IN_FROM_ADDRESS,
      { :include_blank => true },
      html_options.merge( :onchange => "mailFromChanged(this)" ).merge( mail_from_attributes( object_symbol, :select ) )
    )
    
    # Text input field
    output << text_field( object_symbol, :from,
      html_options.merge( :onblur => "mailFromChanged(this)" ).merge( mail_from_attributes( object_symbol, :text ) )
    )
    
    return output.join
  end
  
  private
  
  def mail_from_attributes( object_symbol, tag_type )
    object = instance_variable_get( "@#{object_symbol}" )
    from = object.from
    in_options = BUILT_IN_FROM_ADDRESS.values.include?( from ) || from.blank?
    
    if (tag_type == :select && !in_options) || (tag_type == :text && in_options)
      return { :style => "display: none;", :disabled => "disabled" }
    else
      return {}
    end
    
  end
end