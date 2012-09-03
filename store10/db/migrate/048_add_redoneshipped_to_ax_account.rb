class AddRedoneshippedToAxAccount < ActiveRecord::Migration
  def self.up
    add_column :ax_accounts, :red_one_shipped, :string, :limit => 16, :nul => false, :default => 'No'
  end

  def self.down
    remove_column :ax_accounts, :red_one_shipped
  end
end