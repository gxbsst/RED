class MyAccountMailer < ActionMailer::Base
  
  # Notification for updating customer's email address
  def update_email_address( customer )
    recipients set_recipients( customer.original_email )
    from AppConfig.WEBMASTER_EMAIL_ADDRESS
    sent_on Time.now
    subject "Your RED Digital Cinema registered email address has been changed!"
    body :customer => customer
  end
  
  private
  
  def set_recipients( email_address )
    (RAILS_ENV == 'production') ? email_address : AppConfig.DEBUG_EMAIL_ADDRESS
  end
  
end