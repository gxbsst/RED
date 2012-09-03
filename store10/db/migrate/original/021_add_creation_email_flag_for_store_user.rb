class AddCreationEmailFlagForStoreUser < ActiveRecord::Migration
  def self.up
    add_column :store_users, :creation_email, :boolean, :null => false, :defaults => false
  end
  
  def self.down
    remove_column :store_users, :creation_email
  end
end