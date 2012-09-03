class AddCardHolderNameForCreditCard < ActiveRecord::Migration
  def self.up
    add_column    :order_accounts, :cardholder_name, :string
  end

  def self.down
    remove_column :order_accounts, :cardholder_name
  end
end
