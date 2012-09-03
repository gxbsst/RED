class AxInventory < ActiveRecord::Base
  
  class << self
    def sync
      begin
        update_inventories
      rescue
        # do nothing
      end
    end
    
    def fetch_inventories
      xml = httpagent(:body => request_xml).body
      doc = Hpricot.XML(xml)
      
      items = []
      (doc/:InventTable).each do |item|
        items << self.new({
            :dim_group_id    => (item/:DimGroupId).inner_text,
            :item_group_id   => (item/:ItemGroupId).inner_text,
            :item_id         => (item/:ItemId).inner_text,
            :item_name       => (item/:ItemName).inner_text,
            :item_price      => (item/:ItemPrice).inner_text.to_f,
            :model_group_id  => (item/:ModelGroupId).inner_text,
            :pct_deposit     => (item/:PctDeposit).inner_text.to_f,
            :amt_deposit     => (item/:AmtDeposit).inner_text.to_f,
            :shipping_points => (item/:ShippingPoints).inner_text.to_f,
            :status          => 'UPDATE'
          })
      end
      
      return items
    end
    
    def inventories_variance_report
      variances = inventories_variance()
      unless variances.values.flatten.empty?
        OrdersMailer.deliver_ax_inventories_variance_report(variances)
      end
    end
    
    def inventories_variance
      ax_inventories = fetch_inventories
      local_inventories = self.find(:all)
      
      # initialize variance report container
      variances = {:new_items => [], :removed_items => [], :changed_items => []}
      
      # report variance about new items add to AX
      new_items_id = ax_inventories.map(&:item_id) - local_inventories.map(&:item_id)
      variances[:new_items] = ax_inventories.select {|item| new_items_id.include?(item[:item_id])}
      
      # report variance about items removed from AX
      removed_items_id = local_inventories.map(&:item_id) - ax_inventories.map(&:item_id)
      variances[:removed_items] = local_inventories.select {|item| removed_items_id.include?(item[:item_id])}
      
      # report variance about items changed in AX
      intersections_id = local_inventories.map(&:item_id) & ax_inventories.map(&:item_id)
      variances[:changed_items] = intersections_id.map do |item_id|
        original = local_inventories.find {|item| item.item_id == item_id }
        current  = ax_inventories.find {|item| item.item_id == item_id }
        compare_equal?(original, current) ? nil : [original, current]
      end.compact
      
      return variances
    end
    
    def compare_equal?(original, current)
      ![
        :pct_deposit,
        :item_price,
        :item_name,
        :amt_deposit,
        :shipping_points
      ].detect do |attr|
        original.send(attr) != current.send(attr)
      end
    end
    
    def update_inventories
      # will exit if raise exception at fetch_inventories inprocess
      ax_inventories = fetch_inventories
      
      # destory all exists records before save new data into database.
      connection.execute "TRUNCATE #{table_name}"
      
      ax_inventories.each {|item| item.save}
    end
    
    def request_xml(item_id=0, operator='GreaterOrEqual')
      xml = ""
      doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      doc.instruct!
      doc.soap12:Envelope,
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
        "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
        doc.soap12 :Body do
          doc.findListInventory :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/Inventory" do
            doc.DocumentContext do
              doc.MessageId( UUID.random_create.to_s )
              doc.SourceEndpointUser( AppConfig.SOAP_USER )
              doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
              doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
            end
            doc.QueryCriteria :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/QueryCriteria" do
              doc.QueryCriteriaElement do
                doc.DataSourceName( 'InventTable' )
                doc.FieldName( 'ItemId' )
                doc.Operator( operator )
                doc.Value( item_id )
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
        :url          => AppConfig.SOAP_IN_SERV,
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
