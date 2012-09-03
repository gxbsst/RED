module ERP
  class ERPAgent
    require "hpricot"
    
    # Default options while posting an ERP request
    DEFAULT_OPTIONS = {
      :basic_auth => { :iis_user => AppConfig.IIS_USER, :iis_pass => AppConfig.IIS_PASS },
      :content_type => "application/soap+xml; charset=utf-8;",
      :body => ""
    }
    
    # Return an available http client
    def self.get_http_client(uri, use_ssl = true)
      http = Net::HTTP.new uri.host, uri.port
      if use_ssl
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      
      return http
    end
    
    def self.enqueue(options)
      log = ERPLog.new :service_url => options[:url], :post_body => options[:body], :update_complete => 0
      log.save!
      system("/usr/bin/ruby #{RAILS_ROOT}/script/erp_sync_one #{ENV['RAILS_ENV']} #{log.id} >/dev/null 2>&1 </dev/null &")
      return true
    end
    
    # Post request to WebService
    # Available Parameters:
    #   url, basic_auth, content_type, body
    def self.post(options)
      options = DEFAULT_OPTIONS.merge options
      # Re-post a failed request saved in logs if options[:erp_log] is given.
      log = options[:erp_log] || ERPLog.new(:service_url => options[:url], :post_body => options[:body]) 
      
      uri = URI.parse log.service_url
      http = get_http_client uri
      
      # Setting up an Post
      request = Net::HTTP::Post.new uri.path
      unless options[:basic_auth].blank?
        request.basic_auth options[:basic_auth][:iis_user], options[:basic_auth][:iis_pass]
      end
      request.set_content_type options[:content_type] unless options[:content_type].blank?
      request.body = log.post_body
      
      # Posting
      # TODO:
      #   1. Save current options to LOG before posting, after that save the response.
      #   2. Exception Handler
      begin
        response = http.request(request)
        if request.body =~ /\<MessageId\>([\w-]+)\<\/MessageId\>/
          log.uuid = $1
        end
        log.code = response.code
        log.response = response.body
        # log.update_complete = true
      rescue => e
        log.message = e.message
      ensure
        log.save unless options[:no_log]
      end
      
      if (result = analyze_response( response ))
        log.update_attribute "update_complete", true
        return result
      else
        notify_exception( log )
        
        # [TODO] WESTON
        # Notify the bombsquad to update the orders
        send_mail_to_bombsquad( log )
        return false
      end
    end
    
    # Analyze response
    def self.analyze_response( response )
      return false if response.nil?
      return false unless response.code == "200"
      # return false if Hpricot(response.body)/"soap:fault"
      return response
    end
    
    # Fired if error occured in AX response.
    def self.notify_exception( log )
      ERP::ERPMailer.deliver_synchronization_failed( log )
      # puts "[TODO] Sending ax exception notify"
    end
    
    #[TODO] WESTON
    # Fired if error occured in AX response.
    def self.send_mail_to_bombsquad( log )
      system("/usr/bin/ruby #{RAILS_ROOT}/script/erp_sync_oneX #{ENV['RAILS_ENV']} #{log.id} >/dev/null 2>&1 </dev/null &")
      #  "[TODO] Notify the bombsquad to update the orders"
    end

  end
end
