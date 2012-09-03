class MyAccountLog < ActiveRecord::Base
  include ERP::HelperMethods
  
  attr_reader :record
  

  def source(force_reload=false)
    eval(self.class_name).find( self.record_id )
  end

  def self.web_user_log(web_user, erp_object, description)
    log = self.new
    log.account_num = web_user.erp_account_number
    log.sales_order_num = self.find_order_num(erp_object)
    log.email = web_user.email_address
    log.class_name = erp_object.class.name
    log.record_id = erp_object.id
    #  "./script/../config/../app/controllers/my_account_controller.rb:61:in `contacts'",
    log.action = self.action(caller[1])
    log.description = description
    log.remote_ip = web_user.remote_ip
    log.remote_location = web_user.remote_location
    log.path = web_user.request_path
    log.user_agent = web_user.user_agent
    log.save!
  end
  
  def self.engine_log(engine,erp_object,description)
    log = self.new
    log.account_num = self.find_account_num(erp_object)
    log.sales_order_num = self.find_order_num(erp_object)
    log.class_name = erp_object.class.to_s
    log.record_id = erp_object.id
    log.action = caller[0] =~ /`([^']*)'/ and $1
    log.description = description
    log.user_agent = engine
    log.save!
  end
  
  def self.action(callstring)
    callstring =~ /.*\/(.*\.rb):(\d+):in `([^']*)'/
    return "#{$3}() #{$1}:#{$2}"
  end
  
  # Got
  def record
    options = { :include => "product" } if self.class_name == ERP::SalesLine.name
    record = eval(self.class_name).find_by_id(self.record_id, options)
  rescue
    nil
  end
  
  def description
    if (original_description = super) =~ /^([\s\w]+):.+\((.*)\)/i
      #   if ( $1 == 'Delete Sales Line' ||  $1 == 'Update Sales Line Qty' )
      #   original_description.gsub(/:\s*([-\w\d]+)\s*/i, ': ')
      #   
      # else
      #   original_description
      #   end
      des = $1 + ": " + $2
      return des
    elsif (original_description = super) =~ /^(Move Sales Line).+\b(S.+)\b$/i
      des = $1 + ": " + $2
    else
      original_description
    end
  end
  
  # def user_agent
  #   original_user_agent = super
  #   # patern = {:mac => ['safari', 'firefox', 'opera'], :windows => ['msie', 'firefox', 'safari', 'opera']}
  #   os = (original_user_agent =~ /(windows|mac|linux)/) ? $1 : "Other OS"
  #   browser = (original_user_agent =~ /(safari|msie|firefox|opera)/) ? $1 : "Other Agent"
  #   
  #   return ("OS: " +  os + "<br />" + "Browser: " + browser)
  # end
  

end
