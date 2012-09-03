module StaticPagesHelper
  def buy_now_link
    link_to image_tag('/skin/img/lenses/buynow.png', :alt => 'Buy now!'),
      { :controller => 'store', :action => 'tags', :id => 'Lenses' },
      :title => _('GLOBAL|BUY_NOW')
  end
  
  def radio_group(object, method, values=[])
    result = []
    values.each do |value|
      result << "<span>#{radio_button(object, method, value.titleize)}<label for=\"#{object}_#{method}_#{value.downcase}\">#{value.titleize}</label></span>"
    end
    return result.join
  end
  
  def download_link(code)
    category = @downloads[code].first
    download = category.downloads.first
    
    text = download.nil? ? "#{category.title} (Coming Soon)" : download.display_version
    
    if download.nil?
      "<span>#{text}</span>"
    else
      link_to text, :controller => 'support', :action => 'release_history', :id => category.id
    end
  end
  
  def text_field(object, method, options={})
    super(object, method, options.merge(:class => 'text-input'))
  end
end
