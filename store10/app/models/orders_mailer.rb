class OrdersMailer < ActionMailer::Base
  
  def receipt(order)
    if order.order_summary.buy_now_total > 0.0
      subject "Rush Order: Thank you for your order! (\##{order.order_number})"
    else
      subject "Thank you for your order! (\##{order.order_number})"
    end
    if RAILS_ENV == 'production'
      recipients order.order_user.email_address
    else
      recipients AppConfig.DEBUG_EMAIL_ADDRESS
    end
    unless  order.order_status_code_id == 15 
     cc AppConfig.ORDERS_CC 
    end
    from AppConfig.ORDERS_FROM
    content_type "text/plain"
    body :order => order
    sent_on Time.now
    headers "Errors-To" => "postmaster <postmaster@red.com>"
  end
  
  def failed(order)
    @subject = "An order has failed on the site"
    @body       = {:order => order}
    @recipients = AppConfig.ORDERS_BCC
    @from       = AppConfig.ORDERS_FROM
    @sent_on    = Time.now
  end

  def erp_failed(log)
    @subject     = "ERROR: red.com/ax web service gateway"
    @recipients  = AppConfig.ERP_ERR_TO
    @from        = AppConfig.ERP_ERR_FROM
    @sent_on     = Time.now
    @body['log'] = log
    begin
      log.uuid.blank? ? @body['ex_message'] = 'UUID is empty!' : @body['ex_message'] = ErpHelper.xml2html(ErpOrder.query_err_msg(log.uuid))
    rescue
      @body['ex_message'] = "Query ERP Exception Message Fault!"
    end
  end
    
  def erp_exception(content)
    subject      "ERROR: red.com/ax web service gateway"
    recipients   AppConfig.ERP_ERR_TO
    from         AppConfig.ERP_ERR_FROM
    case content
    when String then
      content_type "text/plain"
      body content
    when Log::OrderErpLog then
      content_type "text/html"
      body :log => content
    end
  end
  
  def ax_variance_report(weekly, orders, pfp_logs, ax_logs,erp_logs, my_account_logs)
    subject "RED.com/AX Variance Report"
    # recipients 'boba@red.com'
    recipients AppConfig.ORDERS_BCC
    from AppConfig.ORDERS_FROM
    body :weekly => weekly, :orders => orders, :pfp_logs => pfp_logs, :ax_logs => ax_logs, :erp_logs => erp_logs, :my_account_logs => my_account_logs
  end
  
  # =============================================================
  # = sync product and erp items accord with axobj reports mail =
  # =============================================================
  def sync_products_and_erp_items
    subject "RED.com/Sync Products Data Report"
    recipients AppConfig.EXCEPTION_RECIPIENTS
    from AppConfig.ORDERS_FROM
    content_type "text/html"
    body :host => AppConfig.HOST_NAME
  end
  
  def sync_products_failed_mail( message )
    subject "RED.com/Sync Products Data Report - FAILED"
    recipients AppConfig.EXCEPTION_RECIPIENTS
    from AppConfig.ORDERS_FROM
    content_type "text/html"
    body :messages => message
  end
  
  def ax_inventories_variance_report(variances)
    subject "RED.com/AX Inventories Variance Report"
    recipients AppConfig.DEBUG_EMAIL_ADDRESS
    from AppConfig.ORDERS_FROM
    body :new_items => variances[:new_items], :removed_items => variances[:removed_items], :changed_items => variances[:changed_items]
  end
  
  def panavision_order(name, company, order_number)
    subject "Panavision Order Alert"
    recipients 'ryan@red.com, brent@red.com, jarred@red.com'
    # recipients 'weixuhong@gmail.com'
    from AppConfig.ORDERS_FROM
    sent_on Time.now
    body :name => name, :company => company, :order_number => order_number
  end
   
  def sdk(obj)
    subject "RED R3D SDK - Developer Application"
    recipients obj.email
    from (RAILS_ENV == 'production') ? 'r3dsdk@red.com' : AppConfig.DEBUG_EMAIL_ADDRESS
    content_type "text/html"
    sent_on Time.now
    body :obj => obj
    # attachment :content_type => "application/pdf", 
    #            :filename => file_name,
    #            :body => File.read("#{RAILS_ROOT}/private/#{file_name}")
    end

    
    def sdk_staff(sdk)
      subject "RED R3D SDK - Developer Application"
      recipients (RAILS_ENV == 'production') ? 'r3dsdk@red.com' : AppConfig.DEBUG_EMAIL_ADDRESS
      # recipients 'weixuhong@gmail.com'
      #from (RAILS_ENV == 'production') ? "#{sdk.first_name} #{sdk.last_name} <r3dsdk@red.com>" : "#{sdk.first_name} #{sdk.last_name} <#{AppConfig.DEBUG_EMAIL_ADDRESS}>"
      from (RAILS_ENV == 'production') ? "#{sdk.first_name} #{sdk.last_name} <#{sdk.email}>" : "#{sdk.first_name} #{sdk.last_name} <#{sdk.email}>"
      content_type "text/html"
      sent_on Time.now
      body :sdk => sdk
    end
    
  
end
