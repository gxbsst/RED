class AccountsController < ApplicationController
  layout 'accounts'

  def login
    case @request.method
      when :post
	      if user = User.authenticate(@params[:user_login], @params[:user_password])
	        @session[:user] = user.id
					flash['notice'] = "Login successful"
	        redirect_to_default( user )
	      else
	        flash.now['notice']  = "Login unsuccessful"
	        @login = @params[:user_login]
	      end
	    when :get
	      if session[:user]
	        redirect_to_default( User.find(@session[:user]) )
        end
    end
  end
  
  def signup
    redirect_to :action => "login" unless User.count.zero?
    
    @user = User.new(@params[:user])
    
    if @request.post? and @user.save
      @session[:user] = User.authenticate(@user.login, @params[:user][:password]).id
      flash['notice']  = "Signup successful"
      redirect_to '/'
    end      
  end  
  
  def logout
    @session[:user] = nil
  end
  
  private
  
  # After login, redirect to the default controller which is accessible to this user.
  def redirect_to_default( user )
    redirect_back_or_default :controller => "admin/#{default_controller(user)}"
  end
  
  # Return the first available controller name
  def default_controller( user )
    user.roles.first.rights.select{ |right| right.controller != "content_nodes" }.first.controller
  end
end
