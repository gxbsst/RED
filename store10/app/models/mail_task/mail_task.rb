class MailTask < ActiveRecord::Base
  
  # each model should mixin MailDB for access instead mail database.
  module MailDB
    def self.included(base)
      # base.establish_connection :mail
      base.connection = MailDBConnection.connection
    end
  end
  
  include MailDB
  
  module General
    def self.included(base)
      base.send :include, MailDB
      base.extend ClassMethods
    end
    
    module ClassMethods
      def init
        init_mail_task
        init_queues
      end
      
      def init_mail_task
        table_name = self.table_name
        unless MailTask.find_by_table_name(table_name)
          MailTask.create(
            :task_name        => 'Please change it',
            :task_description => 'Please change it',
            :table_name       => table_name
          )
        end
      end
      
      # override by sub_queue
      def init_queues
      end
      
      def blast
        self.find(:all, :conditions => ['complete = ?', false]).each do |queue|
          queue.send_mail
        end
        MailTask.find_by_table_name(table_name).update_attribute(:task_date, Date.today.to_s(:db)) if RAILS_ENV == 'production'
      end
      
      def sid_generator
        UUID.random_create.to_s.gsub(/-/,'')
      end
    end
    
    def name
      "#{self.first_name.capitalize} #{self.last_name.capitalize}"
     # first_name =  AxAccount.find(:first, :conditions => ['ax_account_number = ?', self.ax_account_number]).cust_first_name
     #     last_name =  AxAccount.find(:first, :conditions => ['ax_account_number = ?', self.ax_account_number]).cust_last_name
     #     "#{first_name} #{last_name}"
     # self.full_name
    end

    def email_address
      if RAILS_ENV == 'production'
        "#{self[:email_address]}"
      else
         #'gxbsst@gmail.com'
        'boba@raw.red.com'
      end
    end
  
    def email_address_with_name
      if name.blank?
        email_address
      else
        "#{name} <#{email_address}>"
      end
    end
    
    # return absolute path of this mail template.
    def mail_template_file
      File.expand_path(File.join(RAILS_ROOT, 'app', 'views', 'mail_task_mailer',"#{self.class.table_name}.text.html.rhtml"))
    end
  
    # generate url for customer read mail on line.
    def url_for_read_online
      "http://red.com/email/read/#{self.mail_task.id}?sid=#{self.sid}"
    end
    
    # expire date is 30 days after mail sent.
    def expire_time
      updated_at.advance(:days => 30)
    end
    
    def expire_date
      expire_time.strftime('%Y-%m-%d')
    end
    
    def expired?
      Time.now >= expire_time
    end
    
    # general method for send mail.
    # override by subqueue and provider options as params.
    def send_mail(options = {})
      options = {
        :subject => "Message From RED.com",
        :cc      => "",
        :from    => AppConfig.ORDERS_FROM,
      }.merge!(options)
      
      # send mail under development and test environment.
      begin
        mail = MailTaskMailer.send "create_#{self.class.table_name}", self, options
        MailTaskMailer.deliver(mail)
        #self.update_attribute(:complete, true)
      rescue
        # do nothing.
      ensure
        return
      end if RAILS_ENV != 'production'
      
      # send mail under production environment only.
      begin
        mail = MailTaskMailer.send "create_#{self.class.table_name}", self, options
        log = MailTaskSentLog.new(
          :mail_task_id  => mail_task.id,
          :mail_queue_id => id,
          :from          => "#{mail.from}",
          :to            => "#{mail.to}",
          :subject       => mail.subject,
          :body          => mail.body
        )
        MailTaskMailer.deliver(mail)
        self.update_attribute(:complete, true)
        log.sent = true
      rescue
        # do nothing.
      ensure
        log.save
      end
    end
    
    def sent_logs
      MailTaskSentLog.find(:all, :conditions => ['mail_task_id = ? and mail_queue_id = ?', mail_task.id, id])
    end
    
    # associate sub queues and mail_task through table_name,
    def before_save
      mail_task = MailTask.find_by_table_name(self.class.table_name)
      mail_task.nil? ? nil : self.mail_task = mail_task
    end
  end
  
  # return sub queues object by table name.
  def sub_queue_obj
    ActiveRecord::Base.const_get(self.table_name.classify)
  end
  
  # return sub queues count.
  def sub_queue_count
    sub_queue_obj.count
  end
  
  # return all sub queues.
  def sub_queues
    sub_queue_obj.find(:all, :order => "created_at DESC")
  end

  # find sub mail queue by sid.
  def find_queue_by_sid(sid)
    sub_queue_obj.find_by_sid(sid)
  end
end

# # General mailer model
# class MailTaskMailer < ActionMailer::Base
#   private
#   def method_missing(method_name, queue, options)
#     method_def = <<-end_eval
#     def #{method_name}(queue, options)
#     subject options[:subject]
#     recipients queue.email_address_with_name
#     cc options[:cc]
#     from options[:from]
#     headers "Errors-To" => "postmaster <postmaster@red.com>"
#     body :queue => queue
#     end
#     end_eval
#     eval(method_def)
#     send method_name, queue, options
#   end
# end
# 
# class MailTaskSentLog < ActiveRecord::Base
#   #include MailTask::MailDB
#   include MailTask::General
# end
