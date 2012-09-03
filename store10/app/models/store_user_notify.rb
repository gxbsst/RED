class StoreUserNotify < ActionMailer::Base

  def reset_password(user, reset_password_url)
    @subject    = 'Please reset account password on RED.com'
    @body       = { :name => user.name, :url => reset_password_url }
    @recipients = (RAILS_ENV == 'production') ? user.email_address : AppConfig.DEBUG_EMAIL_ADDRESS
    @from       = AppConfig.WEBMASTER_EMAIL_ADDRESS
    @sent_on    = Time.now
    # @headers    = {}
  end
  
  def auto_generated(user, reset_password_url)
    @subject    = 'Your account on RED.com has been generated!'
    @body       = { :name => user.name, :url => reset_password_url }
    @recipients = (RAILS_ENV == 'production') ? user.email_address : AppConfig.DEBUG_EMAIL_ADDRESS
    @from       = AppConfig.WEBMASTER_EMAIL_ADDRESS
    @sent_on    = Time.now
  end

  def news_update(user)
    @subject    = 'RED Digital Cinema - Delivery Schedule Update'
    @body       = { :name => user.name }
    @recipients = (RAILS_ENV == 'production') ? user.email_address : AppConfig.DEBUG_EMAIL_ADDRESS
    @from       = AppConfig.WEBMASTER_EMAIL_ADDRESS
    @sent_on    = Time.now
  end
  
  def production_hold(email_address)
    @subject    = 'Great News! A Production Hold!'
    @recipients = (RAILS_ENV == 'production') ? email_address : AppConfig.DEBUG_EMAIL_ADDRESS
    @from       = AppConfig.WEBMASTER_EMAIL_ADDRESS
    @sent_on    = Time.now
  end
  
  def terms_and_conditions(email)
    @subject    = 'Fwd: RED Terms and Conditions'
    @recipients = (RAILS_ENV == 'production') ? email : AppConfig.DEBUG_EMAIL_ADDRESS
    @from       = "orders@red.com"
    @sent_on    = Time.now
  end
end
