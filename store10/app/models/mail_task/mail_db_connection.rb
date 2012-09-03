# Bug Fix
# "Too Many Connection" exception for all models those included module "MailDB"
class MailDBConnection < ActiveRecord::Base
  establish_connection :mail
end