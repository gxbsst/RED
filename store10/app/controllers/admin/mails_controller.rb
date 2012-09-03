# RED Mail Blaster
# by Jerry Guo <hozaka@gmail.com>
require 'mail_tasks/recipients_conditions'

class Admin::MailsController < Admin::BaseController
  
  # Default page title
  before_filter { |controller| controller.instance_variable_set "@title", "RED Mails Blaster" }
  
  # All tasks list
  def index
    @mail_tasks = MailTasks::Task.find_all_by_deleted( false, :order => "created_at DESC" )
  end
  
  # List of mails in this task
  def task
    @task = MailTasks::Task.find( params[:id] )
  end
  
  # Preview of mail content
  def mail
    mail = MailTasks::Mail.query_by_id( params[:id] )
    render :text => mail.content_with_layout( mail_layout_options ), :layout => false
  end
  
  # Remove task from tasks list (index page)
  def delete_task
    task = MailTasks::Task.find( params[:id] )
    task.update_attribute( :deleted, true )
    flash[:notice] = "Task \"#{task.name}\" has been deleted!"
    redirect_to :action => "index"
  end
  
  # Lock task preventing updates
  def lock_task
    task = MailTasks::Task.find( params[:id] )
    task.update_attribute( :disabled, true )
    flash[:notice] = "Task \"#{task.name}\" has been locked!"
    redirect_to :action => "index"
  end
  
  # Deliver mail
  def deliver
    @mail = MailTasks::Mail.query_by_id( params[:id] )
    # user = User.find( session[:user] ).login
    
    if @mail.deliver( mail_layout_options )
      @mail.task.update_attribute( :sent_at, Time.now )
      flash[:notice] = "Email delivered to \"#{@mail.email}\""
      redirect_to :action => "task", :id => @mail.task.id
    else
      flash[:notice] = "Failed to deliver mail to \"#{@mail.email}\""
      redirect_to :back
    end
  end
  
  # Deliver all unsent mails in current task. If all mails delivered, lock this
  # mails task.
  def deliver_unsent_mails
    task = MailTasks::Task.find(params[:id], :conditions => ['disabled = ?', false])
    # task.update_attribute(:disabled, true) unless task.disabled? # lock
    task_in_background('mail_tasks:deliver_unsent_mails', :task_id => task.id)
    flash[:notice] = "Delivering #{task.mails.count} mails, refresh this page minutes later."
    redirect_to :back
  end
  
  # Edit / Creating mail task
  def edit
    @task = MailTasks::Task.find_or_new( params[:id] )
    
    # User can not modify a disabled / deleted task.
    if @task.disabled || @task.deleted
      flash[:notice] = "Task \"#{@task.name}\" has been locked or deleted."
      redirect_to :action => "index"
      return false
    end
    
    if params[:task].blank? && !@task.mails.empty? # show recipients list while editing a existing task
      @recipients = StoreUser.find_all_by_email_address(
         @task.mails.collect{|mail| mail.email}.uniq, # preventing duplication
         :include => "customer",
         :readonly => true
      )
    else
      @recipients = StoreUser.find_all_by_id(
        params[:task][:recipients].split(",").uniq, # preventing duplication
        :include => "customer",
        :readonly => true
      ) rescue nil
    end
    
    # Assign another template to this task
    if params[:template] && ( template = MailTasks::Template.find(params[:template]) )
      @using_template = true
      @task.template = template
      @task.subject = template.subject
      @task.template_body = template.body
      @task.from = template.from
    end
    
    # Return page with form for GET method
    (render && return) unless request.post?
    
    # For POST method, try to create mail task
    begin
      @task.class.transaction do
        @task.mails.clear; @task.mails_count = 0 # why `clear' can not reset the counter catch?
        @task.attributes = params[:task]
        @task.variables = params[:variables]
        @task.save!
        @task.generate_mails( @recipients, true, mail_layout_options )
      end
      flash[:notice] = "Mail Task named \"#{@task.name}\" has been created successfully!"
      redirect_to :action => "task", :id => @task.id
      
    rescue ActiveRecord::RecordInvalid => exception
      # Validation failed, return to edit page
      flash.now[:notice] = @task.errors.full_messages.join("<br />")
      render && return
      
    rescue => exception
      # Another exception occured, go back with error description
      flash.now[:notice] = "Exception occured while creating mail task.<pre>#{exception.message}</pre>"
      render && return
    end # end of transaction
  end
  
  # Dialog Mode
  # Page for selecting recipients with conditions -- Magic Find
  def select_recipients
    load "app/models/mail_tasks/recipients_conditions.rb"
    @title = "Select Recipients"
    render :layout => "modal"
  end
  
  # Select mail recipients by entering account numbers or RED ONE Serial number directlly.
  def recipients_in_list
    if request.get?
      render :layout => "modal"
      return
    end
    
    list = params[:accounts].strip.split(/\n|,/).uniq
    conditions = [
      "(erp_account_number IN (:list) OR serial_number IN (:list))",
      { :list => list }
    ]
    conditions.first << " AND do_not_contact = false" unless params[:ignore_do_not_contact]
    @recipients = StoreUser.find(
      :all,
      :conditions => conditions,
      :joins => "LEFT OUTER JOIN serial_numbers ON serial_numbers.account_num = erp_account_number",
      :include => "customer"
    ) rescue []
    render :partial => "mail_recipients", :layout => false
  end
  
  # Find recipients within given conditions, and then render partial
  #   template for matched records as list table.
  def recipients
    # load "app/models/mail_tasks/recipient.rb"
    load "app/models/mail_tasks/recipients_conditions.rb"
    
    if params[:ignore_do_not_contact]
      sql = nil
    else
      sql = "do_not_contact = false"
    end
      
    
    @recipients = MailTasks::RecipientsConditions.get_recipients( params[:conditions].values, sql )
    render :partial => "mail_recipients", :layout => false
  end
  
  # Edit / Create mail template
  def template
    @mail_template = MailTasks::Template.find_or_new( params[:id] )

    # For GET
    (render && return) if request.get?
    
    # For Preview
    if params[:commit].downcase == "preview"
      @mail_template.attributes = params[:mail_template]
      render :text => @mail_template.content_for_preview( mail_layout_options )
      return
    end
    
    # For Create / Update
    @mail_template.attributes = params[:mail_template]
    @mail_template.variables = params[:variables]
    if @mail_template.save
      flash[:notice] = "Template \"#{@mail_template.name}\" has been saved successfully!"
      redirect_to :back
    else
      flash.now[:notice] = @mail_template.errors.full_messages.join("<br />")
      render
    end
  end
  
  # Template Guide
  # This page is just a static page for syntex help of template in
  #   Mail Blaster.
  def template_guide
    @title = "Template Guide"
  end
  
  # Mail Preview
  # Display as a button / link beside the "Save Task". When be fired,
  #   show the preview page of selected recipients with a navigator like
  #   "next mail" & "previou mail" for checking up all the mails.
  def preview
    task = MailTasks::Task.new( params[:task] )
    recipient = StoreUser.find( params[:id], :include => "customer", :readonly => true )
    mail = task.generate_mails( [recipient], false, mail_layout_options ).first
    render :text => mail.content_with_layout( mail_layout_options ), :layout => false
  # rescue => exception
    #   headers["Content-Type"] = "text/plain"
    #   render :text => exception.to_yaml, :layout => false
  end
  
  private
  
  def mail_layout_options
    products = Product.find(
      :all,
      :conditions => "erp_product_item <> ''",
      :select => "erp_product_item, name"
    )
    options = {
      :post_back_url => url_for( :controller => "/email", :action => "red_logo" ),
      :base => [request.protocol, request.host].join,
      :products => Hash[*products.collect{|p| [p.erp_product_item, p.name] }.flatten]
    }
  end
  
end