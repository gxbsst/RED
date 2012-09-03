class RestoreOrderAddressFirstLastName < ActiveRecord::Migration
  def self.up
      remove_column :order_addresses, :name
      add_column    :order_addresses, :first_name, :string
      add_column    :order_addresses, :last_name, :string
  end

  def self.down
      add_column    :order_addresses, :name, :string
      remove_column :order_addresses, :first_name
      remove_column :order_addresses, :last_name
  end
end
