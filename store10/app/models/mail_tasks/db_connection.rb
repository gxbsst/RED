module MailTasks
  class DBConnection < ActiveRecord::Base
    establish_connection :mail_tasks
  end
end