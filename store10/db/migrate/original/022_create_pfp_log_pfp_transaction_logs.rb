class CreatePfpLogPfpTransactionLogs < ActiveRecord::Migration
  def self.up
    create_table :pfp_transaction_logs do |t|
      t.column :pfp_serv,         :string
      t.column :store_user_id,    :integer
      t.column :card_name,        :string
      t.column :email_address,    :string
      t.column :remote_address,   :string
      t.column :order_number,     :integer
      t.column :uuid,             :string
      t.column :req_xml,          :text
      t.column :res_xml,          :text
      t.column :status,           :string
      t.column :res_code,         :string
      t.column :res_message,      :string
      t.column :created_on,       :date
      t.column :created_at,       :datetime
      t.column :updated_at,       :datetime
    end
  end

  def self.down
    drop_table :pfp_transaction_logs
  end
end
