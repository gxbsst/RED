# Add additional columns to StoreUser, including:
# * r3dsdk_user: User of R3D SDK
# * post_user: Post user of RED ONE
# * red_user: RED ONE User (non-owner)
# * do_not_contact: Normally, mails should NOT delivered to this contact if its value set to True
# 
# Besides these changes, rename the column 'erp_customers.assign_to' to 'assigned_to'
class ModifyColumnsForMailBlaster < ActiveRecord::Migration
  COLUMNS = [:r3dsdk_user, :post_user, :red_user, :do_not_contact]
  
  def self.up
    COLUMNS.each do |column|
      add_column :store_users, column, :boolean, :null => false, :default => false
      add_index :store_users, column
    end
    
    rename_column :erp_customers, :assign_to, :assigned_to
  end
  
  def self.down
    COLUMNS.each do |column|
      remove_column :store_users, column
    end
    rename_column :erp_customers, :assigned_to, :assign_to
  end
end