class Admin::NewsAdminUsersController < ApplicationController
  layout "news_admin"
  #filter except login
  before_filter :authorize,:except => ["login"]
  def add_user
    if request.get?
      @user=NewsAdminUser.new
    else
      @user =NewsAdminUser.new(params[:news_admin_users])
      if @user.save
        redirect_to :controller => "/news",:action =>"list"
      end
    end
  end
  #admin login
  def login
    if session[:user_id]
      redirect_to :controller => "/news",:action => "list"
    else
      if request.get?
        session[:user_id]=nil
        @user = NewsAdminUser.new
      else
        @user = NewsAdminUser.new(params[:news_admin_users])
        logged_in_user = @user.try_to_login
        if logged_in_user
          session[:user_id] = logged_in_user.id
          redirect_to :controller =>"/news",:action =>"list"
        else
          flash[:notice] = "Invalid user/passord combination"
        end
      end
    end
  end

  def logout
    session[:user_id]=nil
    flash[:notice]="Logged Out"
    redirect_to :controller => '/news',:action => 'list'
  end

  def delete
    NewsAdminUser.find(params[:id]).destroy
    redirect_to :controller =>'/admin/news_admin_users',:action => "list_users"
  end
  def index
    redirect_to :controller =>'/admin/news_admin_users', :action => 'list_users' if session[:user_id]

  end

  def list_users
    @users =NewsAdminUser.find_all
  end
  private
    def authorize
       unless session[:user_id]
         flash[:notice]= "Please Login"
         redirect_to(:controller => "/admin/news_admin_users", :action => "login")
       end
     end
  
end
