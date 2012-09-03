module MailTasksW1
  class Mail < ActiveRecord::Base
    include MailTasksW1::Base
    
    # Associations
    belongs_to :task, :counter_cache => "mails_count"
    has_many :delivery_logs, :order => "created_at desc"
    
  end
end