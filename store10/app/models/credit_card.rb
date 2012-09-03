class CreditCard
  require 'erp/encrypt'

  class << self
    def cookies_key(request)
      addr = request.remote_ip
      uuid = UUID.random_create.to_s
      time = Time.now.to_i.to_s
      return Base64.encode64(Digest::SHA256.digest(addr + uuid + time))
    end

    def validate(params)
      account, address = params[:order_account], params[:order_address]
      errors, result = [],[]

      if account[:cardholder_name].blank?
        errors << '\'Issued to Name\' can\'t blank.'
      end
      if account[:cc_number].gsub(/[^\d]/,'').blank?
        errors << '\'Credit Card Number\' can\'t blank and must be number.'
      elsif !creditcard_luhn_validation?(account[:cc_number])
        errors << 'There appears to be a typo in your Credit Card number.<br/>Please re-enter your card number.<br/ >'
      end
    
      if date_validation = date_expired_validate(account[:expiration_year], account[:expiration_month])
        errors << date_validation
      end
    
      if account[:credit_ccv].gsub(/[^\d]/,'').blank?
        errors << '\'Security Code\' can\'t blank and must be number.'
      end
      if address[:address].blank?
        errors << '\'Address\' can\'t blank.'
      end
      if address[:city].blank?
        errors << '\'City\' can\'t blank.'
      end
      if address[:state].blank?
        errors << '\'State\' can\'t blank.'
      end
      if address[:zip].nil?
        errors << '\'Zip/Post Code\' can\'t blank.'
      end

      errors.empty? ? result.unshift(true) : result.unshift(false) << errors
    end

    # date_expired_validate method behavior as black list
    # year/month can't blank.
    # year/month must be numeric.
    # month range between 1 and 12
    # expiration date must more than current month
    def date_expired_validate(year, month)
      case
      when year.blank? || month.blank? : "'Expiration Year/Month' can't blank."
      when year.match(/\D/) || month.match(/\D/) : "'Expiration Year/Month' must be numeric."
      when !(1..12).include?(month.to_i) : "A valid CreditCard expiration month is required."
      when date_expired_compare?(year, month) : "CreditCard Expiration Date Error:<br />Expiration Date must later than #{Date.today.strftime('%Y%m')}."
      end
    end
    
    def date_expired_compare?(year, month, current_date = Date.today)
      Date.strptime("#{year}-#{month}-01", "%y-%m-%d") <= current_date
    end
    
    def encrypt(controller)
      cookies = controller.send :cookies
      session = controller.send :session
      key = cookies[:cookies_key]
      cc_number = controller.params[:order_account][:cc_number].gsub(/[^\d]/,"")
      credit_ccv = controller.params[:order_account][:credit_ccv].gsub(/[^\d]/,"")
      session[:aes_cc_number]  = Encrypt.aes_encrypt(key, cc_number)
      session[:safe_cc_number] = "XXXX-XXXX-XXXX-#{cc_number[-4,4]}"
      session[:aes_credit_ccv] = Encrypt.aes_encrypt(key, credit_ccv)
      session[:payment_uuid]   = UUID.random_create.to_s
    end

    def decrypt(controller, content)
      cookies = controller.send :cookies
      session = controller.send :session
      key = cookies[:cookies_key]

      case content
      when 'cc_number'
        result = Encrypt.aes_decrypt(key, session[:aes_cc_number])
      when 'credit_ccv'
        result = Encrypt.aes_decrypt(key, session[:aes_credit_ccv])
      end
      return result
    end

    def pfp_process(controller, order)
      cookies = controller.send :cookies
      session = controller.send :session
      request = controller.send :request

      #====================================================
      # Get remote location be request ip address
      #====================================================
      remote_ip         = request.remote_ip
      begin
        remote_location = Ip2address.find_location(remote_ip)
      rescue
        remote_location = "-,-,-"
      end
    
      amount         = order.order_summary.total_due
      payment_uuid   = session[:payment_uuid]
      safe_cc_number = session[:safe_cc_number]
      key            = cookies[:cookies_key]

      cc_number     = Encrypt.aes_decrypt(key, session[:aes_cc_number])
      credit_ccv    = Encrypt.aes_decrypt(key, session[:aes_credit_ccv])
      rsa_cc_number = Encrypt.rsa_encrypt(cc_number)
      req_xml       = request_xml(order, amount, cc_number, credit_ccv)
      cc_type       = creditcard_type(cc_number)
      
      # ===================================================
      # PFP Transaction Begin
      # ===================================================
      uri = URI.parse(AppConfig.PFP_CC_SERV)
      req = Net::HTTP::Post.new(uri.path)
      req.set_content_type('text/xml; charset=utf-8;')
      req['x-vps-timeout'] = '30'
      req['x-vps-vit-os-name'] = 'linux'
      req['x-vps-vit-os-version'] = 'rhel 4'
      req['x-vps-vit-client-type'] = 'ruby on rails'
      req['x-vps-vit-client-certification-id'] = '13fda2433fc2123d8b191d2d011b7fdc'
      req['x-vps-vit-integration-product'] = 'red.com'
      req['x-vps-vit-integration-version'] = '0.01'
      req['x-vps-request-id'] = "#{payment_uuid}"
    
      req.body = req_xml
    
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme.eql? 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      #====================================================
      # Build pfp trunsaction log before http request
      # Replace the REAL Credit Card Number in the XML file
      #====================================================
      safe_req_xml_doc = Hpricot.XML(req_xml)
      (safe_req_xml_doc/:CardNum).inner_html = safe_cc_number
      (safe_req_xml_doc/:CVNum).inner_html   = credit_ccv.gsub(/[\d]/,"X")

      log = PfpTransactionLog.build(
        :pfp_serv        => AppConfig.PFP_CC_SERV,
        :store_user_id   => session[:store_user_id],
        :card_name       => order.account.cardholder_name,
        :email_address   => order.order_user.store_user.email_address,
        :remote_ip       => "#{remote_ip}",
        :remote_location => "#{remote_location}",
        :order_number    => order.order_number,
        :uuid            => session[:payment_uuid],
        :req_xml         => safe_req_xml_doc.to_s,
        :creditcard_type => cc_type,
        :request_header  => req.to_hash.to_yaml
      )
    
      begin
        res = http.request(req)
      rescue SocketError => ex
        log.exception(:res_message => "ConnectionError (#{ex.message})")
        raise
      rescue EOFError => ex
        log.exception(:res_message => "TransactionTimeout (#{ex.message})")
        raise
      rescue
        res.body.blank? ? log.exception({}) : log.exception(:res_xml => "#{res.body}")
        raise
      end

      unless res.kind_of? Net::HTTPSuccess
        log.exception(
          :response_code   => res.code,
          :response_header => res.to_hash.to_yaml,
          :res_xml         => "#{res.body}"
        )
        raise
      end

      doc = Hpricot.XML(res.body)
      result_code    = (doc/:Result).inner_text
      result_message = (doc/:Message).inner_text

      #=============================================
      # Update pfp_trunsaction_log when PFP Response
      #=============================================
      result_xml = ''
      REXML::Document.new(res.body).write(result_xml, 0)
      log.complete(
        :response_code   => res.code,
        :response_header => res.to_hash.to_yaml,
        :res_xml         => result_xml,
        :res_code        => result_code,
        :res_message     => result_message
      )

      result = []
      if result_code == '0'
        pnref    = (doc/:PNRef).inner_text
        authcode = (doc/:AuthCode).inner_text

        case (doc/:IAVSResult).inner_text
        when 'Y'
          avs_result = 'Match'
        when 'N'
          avs_result = 'No Match'
        when 'X'
          avs_result = 'No Provide'
        end

        if (doc/:StreetMatch).inner_text == 'Match'
          avs_streetmatch = true 
        else
          avs_streetmatch = false
        end

        if (doc/:ZipMatch).inner_text == 'Match'
          avs_zipmatch = true 
        else
          avs_zipmatch = false
        end

        account = order.order_user.order_account
        account.update_attributes(
          :pfp_amount          => amount,
          :pfp_pnref           => pnref,
          :pfp_authcode        => authcode,
          :safe_cc_number      => safe_cc_number,
          :encrypted_cc_number => rsa_cc_number,
          :remote_ip           => "#{remote_ip}",
          :remote_location     => "#{remote_location}",
          :avs_result          => avs_result,
          :avs_streetmatch     => avs_streetmatch,
          :avs_zipmatch        => avs_zipmatch
        )

        result << true
      else
        result << false
        result << result_code_to_full_message(result_code, result_message)
      end
      return result
    end
    
    def result_code_to_full_message(code, message)
      code_message_list = {
        '0'    => 'Approved',
        '3'    => 'Invalid transaction type',
        '4'    => 'Invalid amount',
        '5'    => 'Invalid merchant information',
        '7'    => 'Field format error',
        '12'   => 'Declined - We were unable to process this Credit Card. Please try another card.',
        '13'   => 'Referral',
        '23'   => 'Invalid account number. Plase check credit card number.',
        '24'   => 'Invalid expiration date',
        '30'   => 'Duplicate Transaction',
        '104'  => 'Timeout waiting for Processor response',
        '105'  => 'Credit error',
        '112'  => 'Failed AVS check',
        '114'  => 'CVV2 Mismatch',
        '1000' => 'Generic Host (Processor) Error'
      }

      if code_message_list[code]
        return "# #{code}: #{code_message_list[code]}"
      else
        return "Credit Card Processing Gateway Error.<br>
                Please inform customer service that while placing your order you received error.<br>
                # #{code}: #{message}<br><br>"
      end
    end

    # calc creditcard type by creditcard number
    def creditcard_type(cc_number)
      number = cc_number.to_s.gsub(/[^\d]/, "")
      return 'visa' if number =~ /^4\d{12}(\d{3})?$/
      return 'mastercard' if number =~ /^5[1-5]\d{14}$/
      return 'discover' if number =~ /^6011\d{12}$/
      return 'american_express' if number =~ /^3[47]\d{13}$/
      return 'diners_club' if number =~ /^3(0[0-5]|[68]\d)\d{11}$/
      return 'enroute' if number =~ /^2(014|149)\d{11}$/
      return 'jcb' if number =~ /^(3\d{4}|2131|1800)\d{11}$/
      return 'bankcard' if number =~ /^56(10\d\d|022[1-5])\d{10}$/
      return 'switch' if number =~ /^49(03(0[2-9]|3[5-9])|11(0[1-2]|7[4-9]|8[1-2])|36[0-9]{2})\d{10}(\d{2,3})?$/ || number =~ /^564182\d{10}(\d{2,3})?$/ || number =~ /^6(3(33[0-4][0-9])|759[0-9]{2})\d{10}(\d{2,3})?$/
      return 'solo' if number =~ /^6(3(34[5-9][0-9])|767[0-9]{2})\d{10}(\d{2,3})?$/
      return 'unknown'
    end
  
    # retuen true if cc_num can pass luhn validates.
    def creditcard_luhn_validation?(cc_num)
      return false if cc_num.blank?

      number = cc_num.gsub(/[^\d]/,"")
      return false if number.length < 14 && number.length > 16

      sum = 0
      for i in 0..number.length
        weight = number[-1*(i+2), 1].to_i * (2 - (i%2))
        sum += (weight < 10) ? weight : weight - 9
      end

      return true if number[-1,1].to_i == (10 - sum%10)%10
      return false
    end    
    
    def request_xml(order, amount, cc_number, credit_ccv)
      xml = ''
      doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      doc.instruct!
      doc.XMLPayRequest :Timeout => '30', :version => '2.0', :xmlns => "http://www.paypal.com/XMLPay" do
        doc.RequestData do
          doc.Vendor 'reddotcom'
          doc.Partner 'paypal'
          doc.Transactions do
            doc.Transaction do
              doc.Authorization do
                doc.PayData do
                  doc.Invoice do
                    doc.BillTo do
                      doc.Address do
                        doc.Street order.order_account.order_address.address
                        doc.City order.order_account.order_address.city
                        doc.State order.order_account.order_address.state
                        doc.Zip order.order_account.order_address.zip
                        doc.Country order.order_account.order_address.country.fedex_code
                      end
                    end
                    doc.TotalAmt amount
                  end
                  doc.Tender do
                    doc.Card do
                      doc.CardNum cc_number
                      doc.ExpDate Date.strptime("#{order.account.expiration_year}-#{order.account.expiration_month}-01", "%y-%m-%d").strftime("%Y%m")
                      doc.CVNum credit_ccv
                      doc.NameOnCard order.account.cardholder_name
                    end
                  end
                end
              end
            end
          end
        end
        doc.RequestAuth do
          doc.UserPass do
            doc.User AppConfig.PFP_USER
            doc.Password AppConfig.PFP_PASS
          end
        end
      end
    end
  end
end