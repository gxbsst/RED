class AccountController < ApplicationController
  layout 'static_pages'

  # ===================================================================
  # Reset user's password via secirty token.
  # Normally the security token is sent to user's email after he click
  #   the "Forgot Password" link in the page.
  # After validating the security token, a form to reset the password
  #   will be displaied.
  # ===================================================================
  def reset_password
    
    # If security token is invalid, show the error message.
    @user = StoreUser.find_by_security_token params[:token] unless params[:token].blank?
    if @user.nil?
      render :partial => 'invalid_security_token', :layout => true
      return
    end

    # If request method is POST and the security token is valid,
    #   try to update user's password.
    if request.post?

      # Password Validation
      # FIXME:
      # Model validation shoud be placed in StoreUser. But to prevent other exceptions,
      #   we have to do so.
      # This will be fixed in the next version of RED.com.
      @user.errors.add :password, 'Password can not be blank.' if params[:password].blank?
      @user.errors.add :password, 'Password confirmation is incurrect.' if params[:password] != params[:confirm_password]

      # Update user password.
      # If update completed, the security token MUST be updated to a new one. Then display a
      #   successful message.
      if @user.errors.empty? && @user.update_attribute(:password, params[:password])
        @user.update_security_token
        render :partial => 'password_changed', :layout => true
        return true
      elsif @user.errors.empty?
        render :text => 'Failed to update your password. Please try again later.'
      end
    end

    # If request method is not POST or there is any error in user model,
    #   display a page with a form.
    render

  end
  
  # =======================================================
  # Forgot Password Process
  # Validate the user with entered email address, and then
  #   send an email with a reset password link to him.
  # =======================================================
  def forgot_password
    # POST
    if request.post?
      @user = StoreUser.find_by_email_address(params[:user][:email_address])
      
      if @user
        # User with this email exists, sending an email with a reset password link.
        @user.update_security_token
        StoreUserNotify.deliver_reset_password(@user, url_for(:action => 'reset_password', :token => @user.security_token, :host => 'www.red.com'))
        render :partial => 'forgot_password_email_sent', :layout => true
        return
      else
        # User not exists, display an error message.
        flash.now[:message] = _('GLOBAL|MESSAGE|USER_NOT_EXISTS')
      end
    end
  end
  
  def login
    @page_title = _('GLOBAL|SIGN_IN')
    
    # Save the HTTP_REFERER url (redirecting back after login successfully)
    #   and return a form for sign in.
    if request.get?
      session[:return_to] ||= request.env['HTTP_REFERER']
      render(:layout => 'blank')
      return
    end
    
    # User Authentication
    @user = StoreUser.find :first, :conditions => ['email_address = ? AND password = ?', params[:email_address], params[:password]]
    
    # Access only for purchased user.
    if @user
      if flash[:login_mode] != 'all' && !(@user.purchased? || @user.has_already_received_redone?)
        flash.now[:message] = "Sorry, access denied because you have not complete a purchase of RED ONE Camera."
      else
        session[:web_user] = @user
        redirect_to session[:return_to] || homepage_url(:lang => params[:lang])
        session[:return_to] = nil
        return
      end
    else
      flash.now[:message] = 'Invalid email addres or password.'
    end
    
    render :layout => 'blank'
  end
  
  # Sign out
  def logout
    session[:web_user] = nil
    redirect_to :controller => "static_pages", :action => "index"
  end

end
