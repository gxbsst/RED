tasks = MailTasksW1::Task.find(:all, :conditions => [ "created_at >= ? AND id != ?", "2009-03-16 19:24:14", 98])
tasks.each do |task|
	@task = MailTasks::Task.new
	@task.name = task.name
	@task.description = task.description
	@task.subject = task.subject
	@task.from = task.from
	@task.variables = task.variables
	@task.template_body = task.template_body
	@task.template_id = task.template_id
	@task.mails_count = task.mails_count
	@task.created_at = task.created_at
	@task.disabled = task.disabled
	@task.deleted = task.deleted
	@task.sent_at = task.sent_at

	@mails = MailTasksW1::Mail.find( :all, :conditions => ["task_id = ? ", task.id ])

	# For POST method, try to create mail task
	begin
		@task.class.transaction do
			@task.mails.clear; @task.mails_count = 0 # why `clear' can not reset the counter catch?
			@task.save!
			@task.generate_mails( @mails, true )
		end
		puts "Mail Task named \"#{@task.name}\" has been created successfully!"

	rescue ActiveRecord::RecordInvalid => exception
		# Validation failed, return to edit page
		puts @task.errors.full_messages.join("<br />")
	rescue => exception
		# Another exception occured, go back with error description
		puts "Exception occured while creating mail task.<pre>#{exception.message}</pre>"
	end # end of transaction
end