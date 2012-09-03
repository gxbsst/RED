class AddMarkToProductForIndicateWhichNeedSerialNumberProcess < ActiveRecord::Migration
  def self.up
    add_column :products, :for_serial_number, :boolean, :defalut => false
    
    Product.find_by_code("101001").update_attribute(:for_serial_number, true)
  end

  def self.down
    remove_column :products, :for_serial_number
  end
end
