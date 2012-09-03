require 'timeout'  
class Admin::MailTasksController < Admin::BaseController
  def index
    @tasks = MailTask.find(:all, :conditions => ['available = ?', true], :order => 'created_at DESC')
    @title = 'Mail Task List'
  end
  
  def task_index
    @task = MailTask.find(params[:id])
    @title = @task.task_name
  end
  
  def in_place_update
    @queue = MailTask.find(params[:task_id].to_i).sub_queues.find{ |queue| queue.id == params[:id].to_i }
    @queue.update_attribute(params[:attribute], params[:value])
    render :text => @queue.send(params[:attribute])
  end
  
  def preview_mail
    @queue = MailTask.find(params[:task_id].to_i).sub_queues.find{ |queue| queue.id == params[:id].to_i }
    render :file => @queue.mail_template_file
  end
  
  def resend_mail
    begin
      mail_task = MailTask.find(params[:task_id].to_i)
      mail_task.sub_queues.find{ |queue| queue.id == params[:id].to_i }.send_mail
      flash[:notice] = "Resend successful!"
    rescue
      flash[:notice] = "Resend failed!"
    ensure
      redirect_to :action => 'task_index', :id => mail_task
    end
  end
  
  def send_mails
    id = params[:id]
    if !id.nil? 
      begin
        MailTask.find(id).sub_queue_obj.blast
        # mail_task_obj =  MailTask.find(params[:id]).sub_queue_obj
        # mail_task_obj.find(:all,:conditions => ['complete = ?', false ]).each_slice(10) do |queue|
        #   queue.each {|mail| mail.send_mail}
        # end
      rescue
        #Do nothing...
      end
      flash[:notice] = "Send Successfull!"
      redirect_to :controller => 'mail_tasks', :action => 'index'
    else
      redirect_to :controller => 'mail_tasks', :action => 'index' 
    end
  end
end