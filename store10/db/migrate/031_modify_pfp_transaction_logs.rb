class ModifyPfpTransactionLogs < ActiveRecord::Migration
  def self.up
    add_column :pfp_transaction_logs, :response_header, :text
    add_column :pfp_transaction_logs, :response_code,   :string, :limit => 20
  end

  def self.down
    remove_column :pfp_transaction_logs, :response_header
    remove_column :pfp_transaction_logs, :response_code
  end
end
