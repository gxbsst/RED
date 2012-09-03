class AxShippingRate < ActiveRecord::Base
  
  SHIPPING_ZONE_RANGES = 'B'..'U'
  
  class << self
    def sync
      SHIPPING_ZONE_RANGES.each do |shipping_zone|
        begin
          create_or_update_records(shipping_zone)
        rescue
          # do nothing.
        end
      end
    end
    
    def create_or_update_records(shipping_zone)
      xml = httpagent(:body => request_xml(shipping_zone)).body
      doc = Hpricot.XML(xml)
      
      # cleanup all exists records
      exists_records = self.find_all_by_shipping_zone(shipping_zone)
      exists_records.each {|r| r.destroy } unless exists_records.empty?
      
      shipping_rate_tables = []
      (doc/:ShippingRateTable).each do |shipping_rate|
        shipping_rate_tables << {
          :shipping_zone => (shipping_rate/:ShippingZone).inner_text,
          :code          => (shipping_rate/:Code).inner_text,
          :min_points    => (shipping_rate/:MinPoints).inner_text.to_f,
          :max_points    => (shipping_rate/:MaxPoints).inner_text.to_f,
          :retail_price  => (shipping_rate/:RetailPrice).inner_text.to_f,
          :status        => 'UPDATE'
        }
      end
      
      shipping_rate_tables.each { |shipping_rate| self.create(shipping_rate) }
    end    
    
    def request_xml(shipping_zone)
      xml = ""
      doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      doc.instruct!
      doc.soap12:Envelope,
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
        "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
        doc.soap12 :Body do
          doc.findListShippingRates :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates" do
            doc.DocumentContext do
              doc.MessageId( UUID.random_create.to_s )
              doc.SourceEndpointUser( AppConfig.SOAP_USER )
              doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
              doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
            end
            doc.QueryCriteria :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/QueryCriteria" do
              doc.CriteriaElement do
                doc.DataSourceName( "ShippingRateTable" )
                doc.FieldName( "ShippingZone" )
                doc.Operator( "Equal" )
                doc.Value1( shipping_zone )
              end
            end
          end
        end
      end
    end

    def httpagent(options)
      options = {
        :iis_user     => AppConfig.IIS_USER,
        :iis_pass     => AppConfig.IIS_PASS,
        :url          => AppConfig.SOAP_SR_SERV,
        :content_type => "application/soap+xml; charset=utf-8;",
        :body         => ""
      }.merge(options)
    
      # Print request body out to STDOUT
      ErpHelper.logger(options[:body]) if AppConfig.DEBUG_MODE
    
      uri = URI.parse(options[:url])
      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(options[:iis_user], options[:iis_pass])
      request.set_content_type(options[:content_type])
      request.body = options[:body]
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    
      response = http.request(request)
    
      # output response message.
      if AppConfig.DEBUG_MODE
        ErpHelper.logger("HTTP Response Code: #{response.code}", 'purple')
        ErpHelper.logger("HTTP Response Is a HTTPSuccess: #{response.is_a?(Net::HTTPSuccess).to_s}", 'purple')
        ErpHelper.logger(response.body, "purple")
      end

      raise unless response.is_a? Net::HTTPSuccess
      
      return response
    end
  end
  
end
