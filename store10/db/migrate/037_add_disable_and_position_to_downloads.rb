class AddDisableAndPositionToDownloads < ActiveRecord::Migration
  def self.up
    add_column :download_categories, :disable, :boolean, :default => false
    add_column :download_categories, :display_pattern, :string
    add_column :download_categories, :position, :integer
    add_column :downloads, :build_number, :integer
    remove_column :downloads, :name
  end

  def self.down
    remove_column :download_categories, :disable
    remove_column :download_categories, :display_pattern
    remove_column :download_categories, :position
    remove_column :downloads, :build_number
    add_column :downloads, :name, :string
  end
end
