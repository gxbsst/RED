class EmailController < ApplicationController
  
  before_filter { |c| c.send :set_locale, 'en_US' }
  
  # read mail online
  def read
    unless params[:id] && params[:sid]
      redirect_to "/404.html"
      return
    end
    
    begin
      mail_task = MailTask.find(params[:id])
      @queue = mail_task.find_queue_by_sid(params[:sid])

      # Redirect broswer to expired page if this was already expired.
      # TODO: we need new expired page in the future.
      raise if @queue.expired?

      render :file => @queue.mail_template_file
    rescue
      redirect_to "/404.html"
      return
    end
  end
  
  # This action will be fired while user opening mail body.
  # Update mail header to set the status to "OPENED" by matching mail token posted in request parameter.
  # Redirect to the actually logo image.
  def red_logo
    MailTasks::Mail.update_all(
      "read_at = '#{Time.now.to_s(:db)}'",
      [ 'read_at is null and token = ?', params[:id] ]
    ) if RAILS_ENV == 'production'
    redirect_to "/images/mailer/prepare_delivery/head01.png"
  end
  
  # Display the mail content (online version). For each mail generated in "admin/mails", a link to
  # the online edition mail content will be provided in "text/plain" part. Normally, the link refer
  # to this action contains the mail's token. Find out it and then render as HTML page.
  def open
    mail = MailTasks::Mail.find_by_token( params[:id] )
    raise ActiveRecord::RecordNotFound unless mail # raise 404 if mail is not found
    
    options = {
      :post_back_url => url_for( :controller => "/email", :action => "red_logo" ),
      :base => [request.protocol, request.host].join
    }
    render :text => mail.content_with_layout( options ), :layout => false
  end
  
end
