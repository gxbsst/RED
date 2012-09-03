class MailTaskRedoneSerialNumberNotifyQueue < ActiveRecord::Base
  include MailTask::General
  
  belongs_to :mail_task
  
  def send_mail
    options = {
      :subject => "RED ONE Serial Number(s) Issued",
      :cc      => AppConfig.ORDERS_CC
    }
    super(options)
  end
end