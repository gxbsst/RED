# Methods defined in this class are mixed-in mails generator, so you are
# accessible to all these helper methods, such as product_link()
# Textile syntax was supported in mails content and helper methods.
module MailTasks
  module Render
  
    class TemplateHelperMethodError < Exception; end
  
    module TemplateHelper
      # Return a link to product detail page with given product code.
      def item( product_code, display_name=nil )
        product_name = @products[product_code.to_s]
        raise( TemplateHelperMethodError, "Product (#{product_code}) not found." ) if product_name.nil?
        
        display_name ||= product_name
        
        product_url = "/store/product_detail/#{product_code}"
        "\"#{display_name}\":#{link_to(product_url)}"
      end
      
      # Escape HTML
      def h( string )
        return CGI.escapeHTML( string )
      end
      
      private
      
      # Convert relative url to full url
      def link_to( url )
        [@base, url].join("")
      end
    end
  
  end
end