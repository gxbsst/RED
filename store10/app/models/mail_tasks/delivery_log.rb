module MailTasks
  class DeliveryLog < ActiveRecord::Base
    include MailTasks::Base
    
    belongs_to :mails
  end
end