class RoleForAdminAccountsAndPfpLogs < ActiveRecord::Migration
  def self.up
    add_column :pfp_transaction_logs, :creditcard_type, :string, :default => "", :limit => 30
    add_column :pfp_transaction_logs, :request_header,  :text,   :default => ""
    
    Right.create(:name => 'Accounts', :controller => 'accounts', :actions => '*')
    Role.find(1).rights << Right.find_by_controller('accounts')
    Right.create(:name => 'PFP Transaction Logs', :controller => 'pfp_transaction_logs', :actions => '*')
    Role.find(1).rights << Right.find_by_controller('pfp_transaction_logs')
  end

  def self.down
    remove_column :pfp_transaction_logs, :creditcard_type
    remove_column :pfp_transaction_logs, :request_header
    
    Role.find(1).rights.delete(Right.find_by_controller('accounts'))
    Role.find(1).rights.delete(Right.find_by_controller('pfp_transaction_logs'))
    Right.find_by_controller('accounts').destroy
    Right.find_by_controller('pfp_transaction_logs').destroy
  end
end
