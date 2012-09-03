class CreateNewsAdminUsers < ActiveRecord::Migration
  def self.up
    create_table :news_admin_users do |t|
      t.column :name ,:string, :limite => 100
      t.column :hashed_password, :string ,:limite => 40
      t.column :created_at, :datetime
      t.column :created_at, :datetime
      t.column :status, :boolean
      t.column :level, :integer,:limite => 1
    end
  end

  def self.down
    drop_table :news_admin_users
  end
end
