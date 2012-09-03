module SupportHelper
  def title_to_css(title)
    result = []
    title.gsub(' ', '_').each_char do |char|
      result << char unless char =~ /[^\d\w]/
    end
    
    return result.join.downcase
  end
  
  # show platform pic for all available platform of this category
  def platform_images(category)
    images = []
    ['windows', 'mac'].each do |platform|
      images << image_tag("/skin/img/support/icon_#{platform}.png", :title => "#{platform.titleize} Supported") if category.available_platform.include? platform
	end
	
	return images.join(" ")
  end
end