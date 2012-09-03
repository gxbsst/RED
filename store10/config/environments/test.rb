puts "================================\n  TEST ENVIRONMENT\n================================"
# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :smtp
ActionMailer::Base.server_settings = {
  :address              =>  'localhost',
  :port                 =>  25,
  :domain               =>  'hong.red.com'
}

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

######################################
# For Test Configuration
# 0 Disable stub 'HTTP' module
# 1 Enable stub 'HTTP' module
######################################
config.app_config.SOAP_STUB_MODE = 1

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


######################################
# PFP Integration Related Settings...
######################################
config.app_config.PFP_CC_SERV = 'https://pilot-payflowpro.verisign.com/transaction'

config.app_config.LOCAL_HOST_NAME = "http://localhost:3000"
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