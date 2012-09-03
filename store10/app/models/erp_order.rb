class ErpOrder < Order
  # ========================================
  # Requires dependency files
  # ========================================
  require 'erp/erp_validate'
  require 'erp/erp_exceptions'
  require 'erp/gen_erp_xml'
  
  # ========================================
  # Association
  # ========================================
  has_many :erp_order_logs
  
  # ========================================
  # Methods for shortcut access
  # ========================================
  def bill_city
    billing_address.city.blank? ? 'unknow' : billing_address.city
  end
  def ship_city
    shipping_address.city.blank? ? 'unknow' : shipping_address.city
  end
  def bill_country
    billing_address.country.name
  end
  def ship_country
    shipping_address.country.name
  end
  def bill_regionid
    billing_address.country.fedex_code
  end
  def ship_regionid
    shipping_address.country.fedex_code
  end
  def email
    order_user.store_user.email_address.blank? ? 'unknown' : order_user.store_user.email_address
  end
  def company
    case
    when !order_user.store_user.company.blank? then order_user.store_user.company
    when !shipping_address.company.blank? then shipping_address.company
    else
      name
    end
  end
  def first_name
    if !billing_address.first_name.blank?
      return billing_address.first_name
    elsif !shipping_address.nil? && !shipping_address.first_name.blank?
      return shipping_address.first_name
    elsif !order_user.name.blank? && order_user.name.strip =~ /\s/
      return order_user.name.split(' ')[0]
    elsif !account.nil? && !account.cardholder_name.blank? && account.cardholder_name.strip =~ /\s/
      return account.cardholder_name.split(' ')[0]
    else
      return 'unknown first name'
    end
  end
  def last_name
    if !billing_address.last_name.blank?
      return billing_address.last_name
    elsif !shipping_address.nil? && !shipping_address.last_name.blank?
      return shipping_address.last_name
    elsif !order_user.name.blank? && order_user.name.strip =~ /\s/
      return order_user.name.split(' ')[-1]
    elsif !account.nil? && !account.cardholder_name.blank? && account.cardholder_name.strip =~ /\s/
      return account.cardholder_name.split(' ')[-1]
    else
      return 'unknown last name'
    end
  end
  def name
    order_user.store_user.name.blank? ? "#{first_name} #{last_name}" : order_user.store_user.name
  end
  def bill_telephone
    billing_address.telephone.blank? ? 'unknown' : billing_address.telephone
  end
  def bill_state
    billing_address.state.blank? ? 'unknown' : billing_address.state
  end
  def ship_state
    shipping_address.state.blank? ? 'unknown' : shipping_address.state
  end
  def bill_address
    address1 = billing_address.address unless billing_address.address.blank?
    address2 = billing_address.address_two unless billing_address.address_two.blank?
    address = "#{address1}\n#{address2}".strip
    return address.blank? ? 'unknow' : address
  end
  def ship_address
    address1 = shipping_address.address unless shipping_address.address.blank?
    address2 = shipping_address.address_two unless shipping_address.address_two.blank?
    address = "#{address1}\n#{address2}".strip
    return address.blank? ? 'unknow' : address
  end
  def bill_zip
    billing_address.zip.blank? ? 'unknown' : billing_address.zip
  end
  def ship_zip
    shipping_address.zip.blank? ? 'unknown' : shipping_address.zip
  end
  def erp_account_number
    order_user.store_user.erp_account_number
  end
  def erp_account_number=(erp_account_number)
    order_user.store_user.update_attribute('erp_account_number', erp_account_number)
  end
  def payment_type
    order_user.order_account.payment_type
  end
  def creditcard_payment?
    payment_type != 1 ? true : false
  end
  def wire_transfer_payment?
    payment_type == 1 ? true : false
  end
  def nameoncard
    order_user.order_account.cardholder_name
  end
  def encrypted_cc_number
    order_user.order_account.encrypted_cc_number
  end
  def expiration_month
    sprintf("%02d", account.expiration_month)
  end
  def expiration_year
    Time.now.strftime('%Y')[-4,2] + (sprintf("%02d", account.expiration_year))[-2,2]
  end
  def pfp_amount
    order_user.order_account.pfp_amount
  end
  def pfp_authcode
    order_user.order_account.pfp_authcode
  end
  def pfp_pnref
    order_user.order_account.pfp_pnref
  end
  def erp_recid=(erp_recid)
    order_user.order_account.update_attribute :erp_recid, erp_recid
  end
  def erp_recid
    order_user.order_account.erp_recid
  end
  
  # recalculate order_line_items
  def erp_order_line_items
    line_items = []
    # the place of the method 'unique_order_line_items' is Order#unique_order_line_items
    unique_order_line_items.each do |item|
      if item.product.for_serial_number
        item.quantity.times do
          line_items << {:item_id => item.product.erp_product_item, :quantity => '1'}
        end
      else
        line_items << {:item_id => item.product.erp_product_item, :quantity => item.quantity.to_s}
      end
    end
    
    return line_items
  end
  
  # ========================================
  # Send erp exception mail
  # ========================================
  def erp_ex_mail
    if !erp_order_logs.size.eql? 0
      ex_log = erp_order_logs[-1]
      mail = OrdersMailer.create_erp_failed(ex_log)
      mail.set_content_type("text/html")
      OrdersMailer.deliver(mail)
    else
      puts 'This ErpOrder Logs is nil!'
    end
  end
  
  # ==================================================
  # Batch process: process all uncomplement orders
  # ==================================================
  def ErpOrder.process_all
    begin
      ErpOrder.find(:all, :conditions => ['erp_complete = 0 and order_status_code_id <> 15 and created_on <= ?', 30.minutes.ago]).each do |order|
        order.erp_process
      end
    rescue Exception
      ex_log = ErpOrderLog.new(:log_msg => 'Erp Batch process exception')
      mail = OrdersMailer.create_erp_failed(ex_log)
      mail.set_content_type("text/html")
      OrdersMailer.deliver(mail)
      raise
    end
  end
  
  # ========================================
  # Single process: process order itself
  # ========================================
  def erp_process
    begin
      if erp_valid?
        update_attributes :erp_status_msg => 'Erp validate successful'
        ErpOrder.check_connection
        create_erp_customer_account
        create_erp_sales_order
        create_erp_creditcard_web
        update_attributes :erp_complete => true
        return erp_complete
      else
        raise ErpExceptions::ErpValidateException
      end
    rescue ErpExceptions::ErpValidateException
      erp_order_logs << ErpOrderLog.new(:order_number => order_number,
        :erp_serv => AppConfig.SOAP_CU_SERV,
        :log_msg => "Erp validate error<br />#{errors.on(:id).to_s}")
      
      erp_ex_mail
    rescue ErpExceptions::ErpConnectionException
      erp_order_logs << ErpOrderLog.new(:order_number => order_number,
        :erp_serv => AppConfig.SOAP_CU_SERV,
        :log_msg => 'Check connection failed')
      
      erp_ex_mail
    rescue ErpExceptions::ErpResponseEmptyException
      erp_ex_mail
    rescue ErpExceptions::ErpResponseBodyEmptyException
      erp_ex_mail
    rescue ErpExceptions::ErpResponseFault
      erp_ex_mail
    end
  end
  
  # ========================================
  # Create new erp customer account
  # ========================================
  def create_erp_customer_account
    if erp_account_number.blank?
      update_attributes :erp_account_uuid => UUID.random_create.to_s unless erp_account_uuid
      xml = gen_erp_account_xml(erp_account_uuid)
      
      erp_order_logs << ErpOrderLog.new(:uuid => erp_account_uuid,
        :order_number => order_number,
        :erp_serv => AppConfig.SOAP_CU_SERV,
        :xml => xml,
        :log_msg => 'Create erp customer account')
      
      res_body = interaction_with_erp(AppConfig.SOAP_CU_SERV, xml)
      doc = Hpricot.XML(res_body)
      result = (doc/:Value).inner_text
      
      update_attributes(:erp_account_number => result,
        :erp_status_msg => 'Create erp customer account successful')
      
      erp_order_logs << ErpOrderLog.new(:uuid => erp_account_uuid,
        :order_number => order_number,
        :erp_serv => AppConfig.SOAP_CU_SERV,
        :xml => res_body,
        :log_msg => 'Create erp customer account successful')
      
    end
  end
  
  # ========================================
  # Create new erp sales order
  # ========================================
  def create_erp_sales_order
    if erp_order_number.blank?
      update_attributes :erp_order_uuid => UUID.random_create.to_s unless erp_order_uuid
      xml = gen_erp_order_xml(erp_order_uuid)
      
      erp_order_logs << ErpOrderLog.new(:uuid => erp_order_uuid,
        :order_number => order_number,
        :erp_serv => AppConfig.SOAP_SO_SERV,
        :xml => xml, :log_msg => 'Create erp sales order')
      
      res_body = interaction_with_erp(AppConfig.SOAP_SO_SERV, xml)
      doc = Hpricot.XML(res_body)
      result = (doc/:Value).inner_text
      
      update_attributes(:erp_order_number => result,
        :erp_status_msg => 'Create erp sales order successful.')
      
      erp_order_logs << ErpOrderLog.new(:uuid => erp_order_uuid,
        :order_number => order_number,
        :erp_serv => AppConfig.SOAP_SO_SERV,
        :xml => res_body,
        :log_msg => 'Create erp sales order successful')
      
    end
  end
  
  # ========================================
  # Create new erp creditcard web
  # ========================================
  def create_erp_creditcard_web
    if creditcard_payment? && erp_recid.blank?
      update_attributes :erp_cc_uuid => UUID.random_create.to_s unless erp_cc_uuid
      xml = gen_erp_creditcard_xml(erp_cc_uuid)
      
      erp_order_logs << ErpOrderLog.new(:uuid => erp_cc_uuid,
        :order_number => order_number,
        :erp_serv => AppConfig.SOAP_CC_SERV,
        :xml => xml,
        :log_msg => 'Create erp creditcard web')
      
      res_body = interaction_with_erp(AppConfig.SOAP_CC_SERV, xml)
      doc = Hpricot.XML(res_body)
      result = (doc/:Value).inner_text
      
      update_attributes(:erp_recid => result,
        :erp_status_msg => 'Create erp creditcard web successful.')
      
      erp_order_logs << ErpOrderLog.new(:uuid => erp_cc_uuid,
        :order_number => order_number,
        :erp_serv => AppConfig.SOAP_CC_SERV,
        :xml => res_body,
        :log_msg => 'Create erp creditcard web successful')
      
    end
  end
  
  def interaction_with_erp(path,xml)
    uri = URI.parse(path)
    req = Net::HTTP::Post.new(uri.path)
    req.basic_auth(AppConfig.IIS_USER, AppConfig.IIS_PASS)
    req.set_content_type('application/soap+xml; charset=utf-8;')
    req.body = xml
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme.eql? 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    #MyLogger.logger xml
    res = http.request(req)
    #MyLogger.logger res.body, 'purple'
    raise ErpExceptions::ErpResponseEmptyException if res.nil?
    raise ErpExceptions::ErpResponseBodyEmptyException if res.body.nil?
    if res.message.eql? 'Internal Server Error'
      return res.body unless Hpricot.XML(res.body).search("Value").inner_text.empty?
      raise ErpExceptions::ErpResponseFault unless Hpricot.XML(res.body).search("soap:Value").inner_text.empty?
    elsif res.message.eql? 'OK'
      return res.body
    else
      raise ErpExceptions::ErpResponseFault.new(path)
    end
  end
  
  def ErpOrder.check_connection(max_tries = 2)
    tries = 0
    begin 
      logger.info "Start checking #{AppConfig.SOAP_CU_SERV} connection..."
      tries += 1
      uri = URI.parse(AppConfig.SOAP_CU_SERV)
      req = Net::HTTP::Get.new(uri.path)
      req.basic_auth(AppConfig.IIS_USER, AppConfig.IIS_PASS)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme.eql? 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      res = http.request(req)
      return true if res.message.eql? 'OK'
      #rescue SocketError
      #rescue Errno::EHOSTUNREACH
    rescue Exception
      sleep(AppConfig.SOAP_SLEEP_TIME)
      logger.info "Retry after #{AppConfig.SOAP_SLEEP_TIME} second..."
      retry unless tries >= max_tries
      logger.info "Check #{AppConfig.SOAP_CU_SERV} connection failed!"
      raise ErpExceptions::ErpConnectionException
    end
  end
  
  def ErpOrder.query_err_msg(uuid)
    begin
      uri = URI.parse(AppConfig.SOAP_QE_SERV)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme.eql? 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      req1 = Net::HTTP::Post.new(uri.path)
      req1.basic_auth(AppConfig.IIS_USER, AppConfig.IIS_PASS)
      req1.set_content_type('application/soap+xml; charset=utf-8;')
      req1.body = GenErpXml.gen_erp_exception_recid_xml(UUID.random_create.to_s, uuid)
      #MyLogger.logger "\n"+AppConfig.SOAP_QE_SERV
      #MyLogger.logger req1.body
      res1 = http.request(req1)
      #MyLogger.logger res1.body, 'purple'
      doc = Hpricot.XML(res1.body)
      result = ''
      (doc/:Value).each do |recid|
        req2 = Net::HTTP::Post.new(uri.path)
        req2.basic_auth(AppConfig.IIS_USER, AppConfig.IIS_PASS)
        req2.set_content_type('application/soap+xml; charset=utf-8;')
        req2.body = GenErpXml.gen_erp_exception_result_xml(UUID.random_create.to_s, recid.inner_text)
        res2 = http.request(req2)
        REXML::Document.new(res2.body).write(result, 0)
      end
      #MyLogger.logger result
      return result
    rescue Exception => ex
      raise
    end
  end
end
