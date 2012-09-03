class Red::SystemNotify < ActionMailer::Base
  
  def exception_notify(exception, controller)
    @subject = "Exception occured on RED.com!"
    @from = AppConfig.WEBMASTER_EMAIL_ADDRESS
    @sent_on = Time.now
    @recipients = AppConfig.EXCEPTION_RECIPIENTS
    @body = { :exception => exception, :request => controller.request }
  end
  
end