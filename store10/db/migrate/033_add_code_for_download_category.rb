class AddCodeForDownloadCategory < ActiveRecord::Migration
  def self.up
    add_column :download_categories, :code, :string
  end

  def self.down
    remove_column :download_categories, :code
  end
end
