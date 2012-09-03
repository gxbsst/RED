namespace :mail_tasks do
  
  desc "Deliver all unsent mails with given task id"
  task :deliver_unsent_mails => :environment do
    task = MailTasks::Task.find(ENV['TASK_ID'], :conditions => ['disabled = ?', false])
    failure_count = 0
    
    task.mails.each do |mail|
      begin
        mail.deliver(mail_layout_options) if mail.sent_at.blank?
      rescue
        failure_count += 1
      end
      mail.update_attribute(:sent_at, Time.now)
    end
    
    task.update_attribute(:disabled, false)
  end
  
  private
  
  def mail_layout_options
    products = Product.find(
      :all,
      :conditions => "erp_product_item <> ''",
      :select => "erp_product_item, name"
    )
    options = {
      :post_back_url => 'http://www.red.com/email/red_logo',
      :base => 'http://www.red.com',
      :products => Hash[*products.collect{|p| [p.erp_product_item, p.name] }.flatten]
    }
    return options
  end
end