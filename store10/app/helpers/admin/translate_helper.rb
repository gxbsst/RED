module Admin
  module TranslateHelper
    def link_to_alphabet
      links = ('A'..'Z').map do |letter|
        link_to(
          letter,
          { :letter => letter },
          :class => ( "current" if current_page?(:letter => letter) )
        )
      end
      links.unshift(
        link_to( 'All', {}, :class => ("current" if current_page?(:letter => nil)) )
      )
    end
    
    def titleize( string )
      string.titleize.gsub('|', ' &raquo; ')
    end
  end
end