# SHA Fix
require 'digest/sha1'
 class << Digest::SHA1  
   class DigestProxy  
     def initialize(content)  
       @content = content  
     end  
   
     def method_missing(method, *args)  
       Digest::SHA1.send(method, @content)  
     end  
   end  
   
   alias_method :original_new, :new  
   def new(*args)  
     return original_new  if args.empty?  
   
     DigestProxy.new(args.first)  
   end  
 end

# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'plugins/app_config/lib/configuration'


# Globals
ERROR_EMPTY  = 'Please fill in this field.'
ERROR_NUMBER = 'Please enter only numbers (0-9) in this field.'

#Rails::Initializer.run do |c|
  #######################################
  ## Email Configuration
  #######################################
  #c.app_config.ORDERS_CC      = 'boba@red.com'
  #c.app_config.ORDERS_BCC     = 'boba@red.com'
  #c.app_config.ORDERS_FROM    = 'boba@red.com'
  #c.app_config.ERP_ERR_TO     = 'boba@red.com'
  #c.app_config.ERP_ERR_FROM   = 'boba@red.com'
  
  ## Email Address for Debug
  #c.app_config.DEBUG_EMAIL_ADDRESS = "boba@red.com"

  ## The email sent from this address, such as 'Reset Password Email'
  #c.app_config.WEBMASTER_EMAIL_ADDRESS = 'boba@red.com'

  ## Exception Handler
  #c.app_config.EXCEPTION_RECIPIENTS = [

    #'"Ryan Erwin" <ryan@red.com>',
    #'"Weston" <gxbsst@gmail.com>'
  #]
  
  # Additional recipients for handling ERP exception
  c.app_config.ERP_EXCEPTION_RECIPIENTS = c.app_config.EXCEPTION_RECIPIENTS + [
    '"Kick" <kick@red.com>' # Kick is the adminitrator of AX
  ]

  c.app_config.CUSTOMER_STAFF = {
    'Brian'  => 'brianb@red.com',
    'BrianB' => 'brianb@red.com',
    'Brent'  => 'brent@red.com',
    'Chad'   => 'chadk@red.com',
    'Dan'    => 'duran@red.com',
    'John'   => 'restivo@red.com',
    'Hoover' => 'hoover@red.com',
    'Restivo'=> 'restivo@red.com',
    'Justin' => 'justinj@red.com',
    'Kevin'  => 'kevinc@red.com',
    'Kelly'  => 'kelly@red.com',
    'Kadar'  => 'briank@red.com',
    'Marco'  => 'polo@red.com',
    'Mike'   => 'Michaelk@red.com',
    'Nate'   => 'nate@red.com',
    'Polo'   => 'polo@red.com',
    'Randy'  => 'randy@red.com',
    'Sean'   => 'ruggeri@red.com',
    'Travis' => 'travis@red.com'
  }

  ######################################
  # Retry contact Server time interval
  ######################################
  c.app_config.SOAP_SLEEP_TIME = 30

  #=====================================
  # DEBUG MODE: put detail message on stdout
  #=====================================
  c.app_config.DEBUG_MODE = true

  ######################################
  # ERP Server Connection Configuration
  ######################################
  c.app_config.SOAP_USER = 'red.local\rdcwebservice'
  c.app_config.SOAP_SOURCE_ENDPOINT = 'RedDotCom'
  c.app_config.SOAP_DEST_ENDPOINT = 'AxRED'
  c.app_config.ERP_SALES_CURRENCY = 'USD'
  c.app_config.ERP_SALES_GROUP = 'DOM'
  c.app_config.ERP_LANG_ID = 'EN-US'
  c.app_config.ERP_SERVICES_USER = 'dynamicsax'
  c.app_config.ERP_SERVICES_PASSWORD = 'k5ars3q76s3h6b'

  ######################################
  # Wire XFer Payment Information
  ######################################
  c.app_config.WIRE_XFER = {
    :bank_name          => 'Union Bank of California',
    :bank_address       => '1980 Saturn Street, Monterey Park, CA 91755',
    :aba_routing_number => '122000496',
    :swift_code         => 'BOFCUS33MPK',
    :to_credit          => 'Red.com, Inc. dba Red Digital Cinema Camera Company',
    :account_number     => '4501049292'
  }

  ######################################
  # RAS Pubblc Key
  ######################################
  c.app_config.PUBLIC_KEY = "#{RAILS_ROOT}/config/erp_public_key.pem"

  ######################################
  # Ip database
  ######################################
  c.app_config.IP_DATABASE = "#{RAILS_ROOT}/db/ipdb.sqlite3"
  c.app_config.IP_FOR_CHINA_DATABASE = "#{RAILS_ROOT}/db/ipdb_cn_hk_tw.sqlite3"


  ######################################
  # PFP Transaction Request Auth
  ######################################
  c.app_config.PFP_USER = 'website'
  c.app_config.PFP_PASS = 'qrg8f9ad1j3p'

  #####################################
  # The limit of creditcard payment
  #####################################
  c.app_config.CC_PAYMENT_LIMIT = 25000.to_f
  c.app_config.HOST_NAME = "http://prealpha.red.com"
  # Page cache folder
  # c.action_controller.page_cache_directory = "#{RAILS_ROOT}/tmp/page_cache"

  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  c.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  #config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  # config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/cache"

  # Activate observers that should always be running
  #c.active_record.observers = :store_user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  # config.active_record.schema_format = :ruby

  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
require 'uuidtools'
require 'fastercsv'
gem 'RedCloth'
gem 'hpricot'
gem 'gettext', '= 1.10.0'  # sudo gem install gettext
gem 'rmagick'
gem 'sqlite3-ruby'

unless File.file? AppConfig.PUBLIC_KEY
  puts "No such file about 'public_key', public_key required for encrypt sensitive message as part of ERP Process system."
  exit
end

unless File.file? AppConfig.IP_DATABASE
  puts "No such file about 'IP Database', plase create it.\n  rake ipdb:create"
  exit
end

unless File.file? AppConfig.IP_FOR_CHINA_DATABASE
  puts "No such file about 'IP Database', plase create it.\n  rake ipdb:create"
  exit
end
####################################################################
# Customer Defined Helper Module
####################################################################
require 'erp/erp_helper'
require 'pp'

# Start up substruct
Engines.start :substruct

# Shipping Info - Get this from your boys at FedEx
#SHIP_FEDEX_URL = ''
#SHIP_FEDEX_ACCOUNT = ''
#SHIP_FEDEX_METER = ''
#SHIP_SENDER_ZIP = ''
#SHIP_SENDER_COUNTRY = ''

# Authorize.net Info
#PAY_LOGIN = ''
#PAY_PASS = ''
# If this is defined then payment will use it
# If not it defaults to authorize.net
# This is so you can use auth.net's testing facilities
# or perhaps a service like 2CheckOut.com
#PAY_URL = nil
# You don't always need this, but it's used if not nil
#PAY_TRANS_KEY = nil

####################################################################
# RED Configuration Begins Here...
KCODE='UTF8'
$KCODE = 'u'
require 'jcode'
require 'gettext/rails'

$LOCATION_REGEX = /[a-z]{2}_[A-Z]{2}/
$I18N = {
  'en_US' => 'United States - English',
  'zh_CN' => 'China - 简体中文',
  'cs_CZ' => 'Czech Republic - Čeština',
  'es_ES' => 'Spain - Espaňol',
  'ja_JP' => 'Japan - 日本語'
}

$DANGEROUS_GOODS_DUE = {
  "us" => 50,
  "another" => 100
}
#=====================================
# MySQL client side detect connection times out
#=====================================
ActiveRecord::Base.verification_timeout = 14400

# Disable the wrapper of form field tag with an error.
ActionView::Base.field_error_proc = Proc.new do |html, instance|
  html
end

COUNTRIES_MAPPING = Country.find(
  :all, :conditions => "fedex_code IS NOT NULL", :order => "name"
).collect { |country| [country.name, country.fedex_code] }



load 'lib/init_actionmailer.rb'

# Haml template settings
Haml::Template.options = {
  :attr_wrapper => '"'
}
