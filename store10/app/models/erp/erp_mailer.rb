class ERP::ERPMailer < ActionMailer::Base

  def modification_failed( log )
    setup
    subject "[AX/WEB SYNC] My Account Upload Failed"
    body :log => log
  end
  
  # Rails / AX exception notify
  def synchronization_failed( log )
    setup
    subject "[AX/WEB SYNC] Synchronization failed"
    
    if is_ax_exception?( log.response )
      begin
        message = ErpOrder.query_err_msg( log.uuid )
      rescue => e
        message = "Failed to query exception description.\n#{e.message}"
      ensure
        log.update_attribute :message, message
      end
    end
    
    body :log => log
  end
  
  # Record validation failed while processing synchronization
  def invalid_record( customer, exception )
    setup
    subject "[AX/WEB SYNC] Invalid AX Record"
    body :customer => customer, :exception => exception, :source => exception.instance_variable_get( '@source' )
  end

  def need_update_orders( orders, updated_sales_lines )
    sent_on Time.now
    from AppConfig.WEBMASTER_EMAIL_ADDRESS

    #recipients "gxbsst@gmail.com"
    
    recipients orders[:assigned_to]

    cc "ryan@red.com, brent@red.com, kick@red.com, kelly@red.com,  gxbsst@gmail.com, raulm@red.com, chadj@red.com"
    subject "URGENT: My Account - AX Error (#{orders[:account_num]})"
    body :orders => orders, :updated_sales_lines => updated_sales_lines
  end


#   def need_test( orders, updated_sales_lines )
#     sent_on Time.now
#     from AppConfig.WEBMASTER_EMAIL_ADDRESS
# 
#     recipients "gxbsst@gmail.com"
#    
# #    recipients orders[:assigned_to]
# 
# #    cc "ryan@red.com, brent@red.com, kick@red.com, kelly@red.com, hozaka@gmail.com, gxbsst@gmail.com"
#     subject "URGENT: My Account - AX Error (#{orders[:account_num]})"
#     body :orders => orders, :updated_sales_lines => updated_sales_lines
#   end
 
  private
  
  def setup
    from AppConfig.WEBMASTER_EMAIL_ADDRESS
    sent_on Time.now
    recipients AppConfig.ERP_EXCEPTION_RECIPIENTS
  end
  
  def is_ax_exception?( response_body )
    if response_body =~ /Exception Log/
      return true
    else
      return false
    end
  end
  
end
