require 'mail_tasks/render/base'

module MailTasks
  class Mail < ActiveRecord::Base
    include MailTasks::Base
    
    # Associations
    belongs_to :task, :counter_cache => "mails_count"
    has_many :delivery_logs, :order => "created_at desc"
    
    # Validations
    # validates_presence_of :email, :content
    
    # Return valid mail object with id
    def self.query_by_id( id )
      return self.find( id, :conditions => 'task_id is not null' )
    end
    
    # Deliver this mail
    def deliver( layout_options )
      self.class.transaction do
        
        mail = Mailer.create_this_mail( self, layout_options )
        
        log = delivery_logs.build(
          # :assignee => assignee,
          :content => mail.body,
          :successful => Mailer.deliver( mail )
        )
        log.save!
        self.sent_at = log.created_at
        self.save!
        
        return true
      end
    rescue ActiveRecord::RecordInvalid => exception
      return false
    end
    
    # Return mail content wrapped with mailer layout. Usually, this is the
    #   the final result of the mail user will receive.
    def content_with_layout( layout_options )
      render = Render::Base.new
      render.mail_content_with_layout( self, layout_options )
    end
    
    # Return dynamic email address of customer's BombSquad if "from" set to "BombSquad"
    def from
      from = task.template.nil? ? task.from : task.template.from
      if from == 'BombSquad'
        return self.rep_email
      else
        return from
      end
    end
    
    def subject #:nodoc:
      task.template.nil? ? task.subject : task.template.subject
    end
    
  end
end