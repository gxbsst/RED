class MailTaskSentLog < ActiveRecord::Base
  include MailTask::MailDB
  # include MailTask::General
end