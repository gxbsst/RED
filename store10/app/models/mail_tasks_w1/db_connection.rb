module MailTasksW1
  class DBConnection < ActiveRecord::Base
    establish_connection :mail_tasks_w1
  end
end