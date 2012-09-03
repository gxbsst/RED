class AddColumnsToErpItems < ActiveRecord::Migration
  def self.up
    add_column :erp_items, :dangerous, :boolean, :default => false
  end

  def self.down
    remove_column :erp_items, :dangerous
  end
end
