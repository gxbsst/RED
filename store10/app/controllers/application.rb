# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include SubstructApplicationController
  
  # ****************** BLOCK BEGIN ******************
  # Bug Fix by Jerry <hozaka@gmail.com>
  # Methods defined in module Substruct should not be public to ActionController.
  # And codes below will hide these methods.
  # Reference: vendor/plugins/substruct/lib/substruct.lib
  Substruct.instance_methods.each do |method|
    hide_action method
  end
  # NO SimpleCache in our project!!!
  remove_method :cache
  # ****************** BLOCK END ********************


  filter_parameter_logging :cc_number, :credit_ccv, :password, :confirm_password
  init_gettext 'red'
  
  protected

  # before_filter :select_language 
  # Set display language via params[:lang].
  # While it's not provided, using 'en_US' as the default language.
  # -----------------------
  # TODO: About language selector
  # 1.  Detected the language setting of user agent, using it as the default.
  # 2.  Redirect to an language selector page if an invalid params[:lang] is provided.
  # -----------------------
  before_filter :select_language

  def select_language
    if params[:lang] =~ /[a-z]{2}_[A-Z]{2}/
      set_locale params[:lang]
    else
      set_locale 'en_US'
    end
  end

  # Global Exception Handler
  def rescue_action(exception)
    # Return 404 error page for RoutingError or UnknownAction
    if url_not_found?(exception)
      log_error_uri(request)
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return false
    end
    
    super(exception)
  end
  
  def rescue_action_in_public(exception)
    Red::SystemNotify.deliver_exception_notify(exception, self)
    render :file => "#{RAILS_ROOT}/public/500.html", :status => 500
  end

  # Log error request uri
  def log_error_uri(request)
    logger.warn "[#{Time.now.to_s}] Bad Request URI: #{request.request_uri}"
  end
  
  # StoreUser Authentication
  # If user has not logged in, they will be redirect to the login page.
  def user_authentication
    if session[:web_user].blank?
      session[:return_to] = request.request_uri
      redirect_to :controller => 'account', :action => "login"
      return false
    else
      return true
    end
  end
  
  # Whether the exception is a normally exception such as "PAGE NOT FOUND"
  def url_not_found?(exception)
    return ['ActionController::UnknownAction', 'ActionController::RoutingError',
    'ActiveRecord::RecordNotFound'].include?(exception.class.name)
  end
  
  # Run a rails task in background.
  def task_in_background( task_name, options={} )
    options.reverse_merge!(:rails_env => RAILS_ENV)
    args = options.map { |k, v| [k.to_s.upcase, v.to_s].join('=') }
    
    command = "rake #{task_name} #{args.join(' ')} --trace 2>&1 >> /dev/null &"
    system(command)
  end
end
