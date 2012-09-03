module Admin::MailTasksHelper
  def resend_link(task, queue)
    if task.task_date && task.task_date <= Date.today
      link_to "Resend", {:action => 'resend_mail', :task_id => task, :id => queue}, :confirm => "Are you sure?"
    else
      'Resend'
    end
  end
end
