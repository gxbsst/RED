class RemovePfpTransactions < ActiveRecord::Migration
  def self.up
    drop_table :pfp_transactions
  end

  def self.down
    create_table :pfp_transactions do |t|
      t.column :pfp_serv, :string
      t.column :uuid, :string, :limit => 40
      t.column :message, :string, :limit => 20
      t.column :xml, :text
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end
end
