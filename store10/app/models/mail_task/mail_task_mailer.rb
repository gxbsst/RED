# General mailer model
class MailTaskMailer < ActionMailer::Base
  private
  def method_missing(method_name, queue, options)
    method_def = <<-end_eval
    def #{method_name}(queue, options)
    subject options[:subject]
    recipients queue.email_address_with_name
    cc options[:cc]
    from options[:from]
    headers "Errors-To" => "postmaster <postmaster@red.com>"
    body :queue => queue
    end
    end_eval
    eval(method_def)
    send method_name, queue, options
  end
end