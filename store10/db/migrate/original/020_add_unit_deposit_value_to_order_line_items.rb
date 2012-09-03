class AddUnitDepositValueToOrderLineItems < ActiveRecord::Migration
  def self.up
    #=========================================
    # initialize All deposit = price * 0.1
    # initialize All item payment type is deposit
    #=========================================
    execute "UPDATE order_line_items SET unit_deposit = unit_price * 0.1"
  end
  
  def self.down
    #=========================================
    # initialize All deposit = price * 0.1
    # initialize All item payment type is deposit
    #=========================================
    execute "UPDATE order_line_items SET unit_deposit = 0.0"
  end
end
