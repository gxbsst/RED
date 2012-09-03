class AddAxStoreUserLogs < ActiveRecord::Migration
  def self.up
    create_table :ax_store_user_logs do |t|
      t.column :email_address, :string
      t.column :raw_input, :text
      t.column :status, :string
      t.column :message, :text
      t.column :return_message, :text
      t.column :created_at, :datetime
      t.column :created_on, :date
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :ax_store_user_logs
  end
end
