class AddDepositColumnToProducts < ActiveRecord::Migration
  def self.up
    add_column :products,         :deposit,      :float,  :default => 0.0, :null => false
    add_column :order_line_items, :unit_deposit, :float,  :default => 0.0, :null => false
    
    #=========================================
    # initialize All deposit = price * 0.1
    # initialize All item payment type is deposit
    #=========================================
    execute "UPDATE products SET deposit = price * 0.1"
    
    #=========================================
    # Change All STICKER Deposit to payoff
    #=========================================
    #10'' LOGO STICKER
    #Product.find_by_code('900-01-003').update_attributes(:deposit => 20)
    #6" LOGO STICKER
    #Product.find_by_code('900-01-002').update_attributes(:deposit => 10)
    #3'' LOGO STICKER
    #Product.find_by_code('900-01-001').update_attributes(:deposit =>  5)
    #20" LOGO STICKER
    #Product.find_by_code('900-01-004').update_attributes(:deposit => 50)
    #Buzzsaw (9'')
    #Product.find_by_code('900-01-005').update_attributes(:deposit => 25)
    #Chainsaw (9'')
    #Product.find_by_code('900-01-006').update_attributes(:deposit => 25)
  end
  
  def self.down
    remove_column :products,         :deposit
    remove_column :order_line_items, :unit_deposit
  end
end
