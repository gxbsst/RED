class AddDisabledAndDeleted < ActiveRecord::Migration
  def self.up
    add_column :tasks, :disabled, :boolean, :null => false, :default => false
    add_column :tasks, :deleted, :boolean, :null => false, :default => false
  end
  
  def self.down
    remove_column :tasks, :disabled
    remove_column :tasks, :deleted
  end
end