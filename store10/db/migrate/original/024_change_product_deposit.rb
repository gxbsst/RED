class ChangeProductDeposit < ActiveRecord::Migration
  def self.up
    execute "UPDATE products SET deposit = 0 where id in (24,25,26,27,28,29)"
  end

  def self.down
    execute "UPDATE products SET deposit = price * 0.1 where id in (24,25,26,27,28,29)"
  end
end
