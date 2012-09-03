class AddProductLocal < ActiveRecord::Migration
 def self.up
   create_table 'product_locals' do |t|
     t.column 'product_id', :integer
     t.column 'cn_price', :float,  :default => 0.00 
     t.column 'hk_price', :float, :default => 0.00
     t.column 'tw_price', :float,  :default => 0 
   end 
  
   add_index :product_locals, "product_id"
 end

 def self.down
   drop_table :product_locals
 end
end
