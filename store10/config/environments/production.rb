puts "================================\n  PRODUCTION ENVIRONMENT\n================================"
# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Force production environments logger level
# (by default production uses :info)
# config.log_level = :warn

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_extensions         = true
config.action_view.debug_rjs                         = false
config.action_mailer.raise_delivery_errors = false

config.action_mailer.delivery_method = :smtp
config.action_mailer.server_settings = {
  :address              =>  'localhost',
  :port                 =>  25,
  :domain               =>  'hong.red.com'
}


######################################
# ERP Server Connection Configuration
######################################
config.app_config.IIS_USER = 'rdcwebservice@red.local'
config.app_config.IIS_PASS = '$rdc#rdcws'

config.app_config.SOAP_CU_SERV = 'https://axobj.red.local/DynamicsWebService/CustomersService.asmx'
config.app_config.SOAP_SO_SERV = 'https://axobj.red.local/DynamicsWebService/SalesOrderService.asmx'
config.app_config.SOAP_CC_SERV = 'https://axobj.red.local/DynamicsWebService/CreditCardWebService.asmx'
config.app_config.SOAP_SR_SERV = 'https://axobj.red.local/DynamicsWebService/ShippingRatesService.asmx'
config.app_config.SOAP_IN_SERV = 'https://axobj.red.local/DynamicsWebService/InventoryService.asmx'
config.app_config.SOAP_QE_SERV = 'https://axobj.red.local/DynamicsWebService/SysExceptionTableService.asmx'

######################################
# Email Configuration
######################################
config.app_config.ORDERS_CC = 'orderhistory@red.com'

######################################
# PFP Integration Related Settings...
######################################
config.app_config.PFP_CC_SERV = 'https://pilot-payflowpro.verisign.com/transaction'
#config.app_config.PFP_CC_SERV = 'https://payflowpro.verisign.com/transaction'

config.app_config.HOST_NAME = "http://www.red.com/"