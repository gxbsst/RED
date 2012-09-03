class AddErpSupportColumnAndTable < ActiveRecord::Migration
  def self.up

    
    create_table :erp_order_logs do |t|
      t.column :erp_order_id,     :integer
      t.column :uuid,             :string,    :limit => 40
      t.column :order_number,     :string
      t.column :erp_serv,         :string
      t.column :log_msg,          :string
      t.column :xml,              :text
      t.column :created_on,       :datetime
      t.column :updated_on,       :datetime
    end

    create_table :pfp_transactions do |t|
      t.column :pfp_serv,         :string
      t.column :uuid,             :string,    :limit => 40
      t.column :message,          :string,    :limit => 20
      t.column :xml,              :text
      t.column :created_on,       :datetime
      t.column :updated_on,       :datetime
    end

    #add_column :store_users,    :security_token,      :string,  :limit => 40
    #add_column :store_users,    :erp_account_number,  :string
    add_column :orders,         :erp_order_number,    :string
    add_column :orders,         :erp_status_msg,      :string
    add_column :orders,         :erp_account_uuid,    :string,  :limit => 40
    add_column :orders,         :erp_order_uuid,      :string,  :limit => 40
    add_column :orders,         :erp_cc_uuid,         :string,  :limit => 40
    add_column :orders,         :erp_complete,        :boolean, :default => false
    add_column :orders,         :pre_ax,              :boolean, :default => false
    add_column :order_accounts, :safe_cc_number,      :string
    add_column :order_accounts, :encrypted_cc_number, :text
    add_column :order_accounts, :remote_ip,           :string
    add_column :order_accounts, :pfp_amount,          :float
    add_column :order_accounts, :pfp_pnref,           :string
    add_column :order_accounts, :pfp_authcode,        :string
    add_column :order_accounts, :avs_result,          :string
    add_column :order_accounts, :avs_streetmatch,     :boolean
    add_column :order_accounts, :avs_zipmatch,        :boolean
    add_column :order_accounts, :erp_recid,           :string
    remove_column :order_accounts, :credit_ccv
  end

  def self.down
    drop_table :erp_order_logs
    drop_table :pfp_transactions
    #remove_column :store_users,    :security_token
    #remove_column :store_users,    :erp_account_number
    remove_column :orders,         :erp_order_number
    remove_column :orders,         :erp_status_msg
    remove_column :orders,         :erp_account_uuid
    remove_column :orders,         :erp_order_uuid
    remove_column :orders,         :erp_cc_uuid
    remove_column :orders,         :erp_complete
    remove_column :orders,         :pre_ax
    remove_column :order_accounts, :safe_cc_number
    remove_column :order_accounts, :encrypted_cc_number
    remove_column :order_accounts, :remote_ip
    remove_column :order_accounts, :pfp_amount
    remove_column :order_accounts, :pfp_pnref
    remove_column :order_accounts, :pfp_authcode
    remove_column :order_accounts, :avs_result
    remove_column :order_accounts, :avs_streetmatch
    remove_column :order_accounts, :avs_zipmatch
    remove_column :order_accounts, :erp_recid
    add_column    :order_accounts, :credit_ccv,  :integer,  :limit => 5
  end

end
