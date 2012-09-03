class AddPaymentTypeToOrderAccount < ActiveRecord::Migration
  def self.up
    add_column    :order_accounts, :payment_type, :integer 
  end

  def self.down
	remove_column :order_accounts, :payment_type
  end
end
