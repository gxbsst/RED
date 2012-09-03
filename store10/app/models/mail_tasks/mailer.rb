# Mailer for delivering mail tasks
# Rendering all tempaltes inline via ERB
require "erb"

module MailTasks
  class Mailer < ActionMailer::Base
    
    BASE_URL = "http://www.red.com"
    
    # Deliver mail to user
    # Normally called by MailTasks::Mail#deliver
    def this_mail( mail, options )
      subject        mail.subject
      recipients     setup_recipients( mail.email )
      from           mail.from
      body           options.merge( :mail => mail )
    end
    
    private
    
    # Deliver mails actually in production environment.
    # In other cases, send mails to testing email address.
    def setup_recipients( email )
      if RAILS_ENV == 'production'
        return email
      else
        return AppConfig.DEBUG_EMAIL_ADDRESS
      end
    end
    
  end
end