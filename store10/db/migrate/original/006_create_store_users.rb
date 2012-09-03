class CreateStoreUsers < ActiveRecord::Migration
  def self.up
    create_table :store_users do |t|
		t.column :name, :string
      	t.column :company, :string
      	t.column :email_address, :string
      	t.column :password, :string
		t.column :ship_to_address_id, :integer
		t.column :bill_to_address_id, :integer
		t.column :order_account_id, :integer
    end
    remove_column :order_users, :confirm_email
	remove_column :order_users, :confirm_password
	add_column    :order_users, :store_user_id, :integer 
  end

  def self.down
    drop_table :store_users
    add_column    :order_users, :confirm_email, :string
    add_column    :order_users, :confirm_password, :string
	remove_column :order_users, :store_user_id
  end
end
