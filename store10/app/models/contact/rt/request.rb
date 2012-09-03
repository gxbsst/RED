require 'uri'
require 'net/https'
require 'timeout'
require 'contact/rt/multipart_post'

module Contact
  module Rt
    CONNECTION_TIMEOUT = 10000
    
    class Request
      def initialize(ticket)
        @ticket = ticket
        
        uri = URI.parse(SETTINGS['server_settings']['new_ticket_url'])
        
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.use_ssl = true
        
        @post = Net::HTTP::Post.new(uri.path)
        if (auth = SETTINGS['server_settings']['basic_auth'])
          @post.basic_auth(auth['username'], auth['password'])
        end
      end
      
      def post
        if @ticket.attachment # multipart
          MultipartPost.to_multipart(@post, @ticket.rt_fields)
        else
          @post.set_form_data(@ticket.rt_fields, ';')
        end
        
        response = @http.start { |http| http.request(@post) }
        return request_successed?(response)
      end
      
    private
      def request_successed?(response)
        response.code == '302' &&
          response.header['location'] =~ /Ticket\/Display.html\?id\=(\d+)/
      end
    end
    
    # Contact ticket can be submitted to RT server after including this module.
    # Exception <code>Contact::Ticket::PostingUnsavedTicket</code> will raise
    # when attempt to commit a ticket which is not saved in local database.
    # 
    # Example:
    #   ticket = Contact::Ticket.find(1)
    #   ticket.submit
    #   # => returns 'true' if posted successfully or 'false' if failed
    module Submitable
      class UnsavedTicket < Exception; end
      
      def submit
        raise(UnsavedTicket, 'Can not submit a ticket before save.') if new_record?
        
        request = Rt::Request.new(self)
        begin
          Timeout::timeout(Rt::CONNECTION_TIMEOUT) do
            return request.post && update_attribute(:submitted, true)
          end
        rescue
          return false
        end
      end
    end
    
  end
end
