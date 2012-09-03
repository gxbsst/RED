# RED Mails Blaster Render
# Render mail contents with this class
require 'mail_tasks/render/binder'

module MailTasks
  module Render
    class RenderError < Exception; end
    
    class Base
      def initialize( template="", binding_options={} )
        @template = template
        @binder = Binder.new( binding_options )
      end
      
      # Render mail content
      def mail_content
        content_without_layout = ERB.new( @template ).result( @binder.get_binding )
      end
      
      # Wrap mail content with mailer layout. The "layout_options" passed in should contains "base" and "post_back_url".
      # Referer to "app/views/mail_tasks/mailer/this_mail.text.html.rhtml"
      def mail_content_with_layout( mail, layout_options={} )
        tmail = Mailer.create_this_mail( mail, layout_options )
        tmail.parts.find{ |mail| mail.content_type == 'text/html' }.body
      end
      
    end
  end
end