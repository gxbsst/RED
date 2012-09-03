class AddTransactionToOrder < ActiveRecord::Migration
  def self.up
    add_column    :orders, :transaction_id, :string 
    add_column    :orders, :authorization_code, :string 
  end

  def self.down
  	remove_column :orders, :transaction_id
  	remove_column :orders, :authorization_code
  end
end
