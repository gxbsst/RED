class AddColumnsToErpLogs < ActiveRecord::Migration
  def self.up
    add_column :erp_logs, :account_num, :string
    add_column :erp_logs, :sales_id, :string
    add_column :erp_logs, :error_description, :text
    add_column :erp_logs, :email_sent, :boolean, :default => false
  end

  def self.down
    remove_column :erp_logs, :email_sent
    remove_column :erp_logs, :error_description
    remove_column :erp_logs, :sales_id
    remove_column :erp_logs, :account_num
  end
end
