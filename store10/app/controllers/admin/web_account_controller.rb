# Operations for web account
require 'erp_log/ax_store_user_log'
class Admin::WebAccountController < ApplicationController
   
  layout false

  # Create a store user with an encrypted password.
  # The end user MUST reset their password via receiving the confirm email.
  # NOTE:
  #   HTTP Basic Authenicate is required for this action.
  #   Send a confirmation email if user is newly created.(user.is_newly_created == true)
  def create
    
    # Render an page with a form unless the request method is POST.
    render && return unless request.post?
        
    headers['Content-Type'] = 'text/plain'

    @user = StoreUser.check_or_create_user(params[:user], request.raw_post)

    # If the attributes of user is invalid, render an page with a form,
    #   and diplay the error messages on it.
    unless @user && @user.errors.empty?
      render :text => @user.errors.collect{ |attr, msg| msg}.join("\n")
      return
    end
    
    # User is valid.
    if @user.is_newly_created

      # This user is newly created with an encrypted password.
      # Send an confirmation email to the user to reset the password.
      begin
        StoreUserNotify.deliver_auto_generated(@user, url_for(:controller => '/account', :action => 'reset_password', :token => @user.security_token, :host => 'www.red.com'))
        @user.update_attribute(:creation_email, 1)
      end
      
      render :text => '0'
    else
      render :text => '0'
    end
  rescue => e
    rescue_action(e)
    erase_results
    render :text => "Exception Occured:\n----------------\n#{e.to_yaml}"
  end

  
  protected
  
  # HTTP Basic Authenticate Process
  before_filter :http_authenticate
  def http_authenticate

    # SSL connection is required.
    # if RAILS_ENV == 'production' && !request.ssl?
    #   redirect_to params.merge(:protocol => 'https://', :controller => '/admin/web_account')
    #   return false
    # end
    
    # HTTP Authenticate
    authorization = request.env['HTTP_AUTHORIZATION'] || request.env['X-HTTP_AUTHORIZATION'] || request.env['X_HTTP_AUTHRIZATION']
    return false if request.nil?
    
    decoded = Base64.decode64(authorization.split.last) unless authorization.blank?
    username = AppConfig.ERP_SERVICES_USER
    password = AppConfig.ERP_SERVICES_PASSWORD
    if decoded == "#{username}:#{password}"
      return true
    else
      # Access denied.
      # Rendering an error page with response code: 401.
      headers['WWW-Authenticate'] = "Basic realm=\"red.com\""
      render :text => '<h1>Access denied.</h1>', :status => 401
      return false
    end
  end

end
