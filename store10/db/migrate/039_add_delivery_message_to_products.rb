class AddDeliveryMessageToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :delivery_message, :string
  end

  def self.down
    remove_column :products, :delivery_message
  end
end
