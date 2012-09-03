class AddIndexToOrderAddressesForOptimizePerformance < ActiveRecord::Migration
  def self.up
    add_index :order_addresses, :first_name
    add_index :order_addresses, :last_name
  end

  def self.down
    remove_index :order_addresses, :first_name
    remove_index :order_addresses, :last_name
  end
end
