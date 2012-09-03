class AddOrderEmailReceiptSent < ActiveRecord::Migration
  def self.up
    add_column    :orders, :sent_email_receipt, :boolean 
  end

  def self.down
    remove_column :orders, :sent_email_receipt
  end
end
