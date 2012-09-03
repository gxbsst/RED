class ERP::ERPLog < ActiveRecord::Base
  set_table_name "erp_logs"

  establish_connection RAILS_ENV.to_sym
end
