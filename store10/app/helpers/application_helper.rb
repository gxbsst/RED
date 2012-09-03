# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    return @page_title unless @page_title.blank?
    title = ['RED']
    title << params[:controller].titleize unless params[:controller] == 'static_pages'
    title << params[:action].titleize unless params[:action] == 'index'
    return title.join(' / ')
  end
  
  def stylesheet_if_exists(*stylesheets)
    results = []
    stylesheets.each do |file_name|
      results << stylesheet_link_tag(file_name) if File.exist?("#{RAILS_ROOT}/public/stylesheets/#{file_name}.css")
    end
    
    return results.join("\n")
  end
  
  def currency_tag(price)
    _('GLOBAL|CURRENCY_SYMBOL') + price
  end
  
  # Generate navigation links with "current" class.
  def nav_link_to(name, options={}, html_options={})
    # options[:action] ||= 'index'
    # params[:action] ||= 'index'
    
    if options[:action].blank? && options[:controller].to_s == params[:controller].to_s
      is_current_section = true
    elsif current_page?(options)
      is_current_section = true
    end
    html_options.merge!(:class => 'current') if is_current_section
    
    return link_to(name, options, html_options)
  end
  
  # Show an message box if flash[:message] is not empty.
  def show_message
    return nil if flash[:message].blank?
    "<div id=\"message\">#{flash[:message]}</div>"
  end
  
  # Language Selector
  def language_selector(default)
    select_tag 'lang', options_for_select($I18N.collect{|key, value| [value, key]}, default),
      :id => 'language_selector',
      :onchange => "switchLanguage(this.value)"
  end
  
  # ==================================
  # Text Format methods
  # Replacing special character with HTML tag
  # ==================================
  
  # Text formater
  # Place each line in "<p>" tag.
  def p(text)
    format_lines(text, 'p')
  end
  
  # Text formater
  # Place each line in "<li>" tag
  def l(text)
    format_lines(text, 'li')
  end
  
  # Text formater
  # Replace each block splited by '\t' in a "<span>" tag
  def span(text)
    result = []
    text.each_line do |line|
      result << line.gsub(/([^\t]+)\t+/, '<span>\1</span>')
    end
    return result.join
  end
  
  def br(text)
    text.gsub(/\n/, '<br />')
  end
  
  # Text Formater
  # Call this metod if the resurce key is end with "|RICH_CONTENT", "|TEXT" or "|CONTENT".
  # All the Textile symbols will be convert into HTML tags.
  def _(string, options={})
    text = super(string)
    return "" if text.blank?
    
    if options[:lite_mode] || (string =~ /(RICH_CONTENT|TEXT|CONTENT)$/).blank?
      return RedCloth.new(text, [:hard_breaks, :no_span_caps, :lite_mode]).to_html
    else
      return RedCloth.new(text, [:hard_breaks, :no_span_caps]).to_html
    end
  end
  
  def textile(string, rules=[:no_span_caps])
    return '' unless string
    RedCloth.new(string, rules).to_html
  end
  
  #==============================================
  # Rounding float to two decimal place
  # 1.234 => 1.23
  # 1.235 => 1.24
  #==============================================
  def roundf(number)
    return ((number * (10 ** 2)).round.to_f)/(10**2)
  end
  
  def labeled_text_field(label, object, method, html_options={})
    result = "<label for=\"#{object}_#{method}\">#{label}</label>"
    result << text_field(object, method, { :class => "input_field" }.merge(html_options))
    return result
  end
  
  private
  def format_lines(text, tag)
    text.gsub(/^/, "<#{tag}>").gsub(/$/, "<\/#{tag}>\n")
  end
end
