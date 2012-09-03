puts "================================\n  DEVELOPMENT ENVIRONMENT\n================================"
# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Enable the breakpoint server that script/breakpointer connects to
config.breakpoint_server = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_extensions         = false
config.action_view.debug_rjs                         = true

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
#config.action_mailer.delivery_method = :test
config.action_mailer.delivery_method = :smtp

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true


######################################
# Retry contact Server time interval
######################################
config.app_config.SOAP_SLEEP_TIME = 2


######################################
# ERP Server Connection Configuration
######################################
config.app_config.IIS_USER = 'rdcwebservice@red.local'
config.app_config.IIS_PASS = '$rdc#rdcws'

config.app_config.SOAP_CU_SERV = 'https://axobj-test01.red.local/DynamicsWebService/CustomersService.asmx'
config.app_config.SOAP_SO_SERV = 'https://axobj-test01.red.local/DynamicsWebService/SalesOrderService.asmx'
config.app_config.SOAP_CC_SERV = 'https://axobj-test01.red.local/DynamicsWebService/CreditCardWebService.asmx'
config.app_config.SOAP_SR_SERV = 'https://axobj-test01.red.local/DynamicsWebService/ShippingRatesService.asmx'
config.app_config.SOAP_IN_SERV = 'https://axobj-test01.red.local/DynamicsWebService/InventoryService.asmx'
config.app_config.SOAP_QE_SERV = 'https://axobj-test01.red.local/DynamicsWebService/SysExceptionTableService.asmx'
# New WebService
config.app_config.SOAP_SO_UPDATE_SERV = 'https://axobj-test01.red.local/DynamicsWebService/SalesOrderUpdateService.asmx'
config.app_config.SOAP_CU_UPDATE_SERV = 'https://axobj-test01.red.local/DynamicsWebService/CustomerUpdateService.asmx'

######################################
# PFP Integration Related Settings...
######################################
config.app_config.PFP_CC_SERV = 'https://pilot-payflowpro.verisign.com/transaction'

# Email Address for Debug
config.app_config.EXCEPTION_RECIPIENTS = "boba@red.com"

######################################
# Mailer server setting
######################################
require 'smtp_tls'
ActionMailer::Base.server_settings = {
  :address              =>  "smtp.red.com",
  :port                 =>  587,
  :domain               =>  'hong.red.com',
  :authentication => :plain,
  :user_name => "boba",
  :password => "betabetabeta"
}

require 'ruby-debug'