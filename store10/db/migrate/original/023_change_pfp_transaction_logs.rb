class ChangePfpTransactionLogs < ActiveRecord::Migration
  def self.up
    remove_column :pfp_transaction_logs,  :remote_address
    add_column    :pfp_transaction_logs,  :remote_ip,       :string
    add_column    :pfp_transaction_logs,  :remote_location, :string
    add_column    :order_accounts,        :remote_location, :string 
  end

  def self.down
    add_column    :pfp_transaction_logs,  :remote_address,  :string
    remove_column :pfp_transaction_logs,  :remote_ip
    remove_column :pfp_transaction_logs,  :remote_location
    remove_column :order_accounts,        :remote_location
  end
end
