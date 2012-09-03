class AddLinuxToSdkSurveys < ActiveRecord::Migration
  def self.up
    add_column :sdk_surveys, :linux,  :boolean, :default => false
    add_column :sdk_surveys, :select_releases,  :boolean, :default => false
    add_column :sdk_surveys, :sid,  :string
    
  end

  def self.down
    remove_column :sdk_surveys, :linux
    remove_column :sdk_surveys, :select_releases
    remove_column :sdk_surveys, :sid
  end
end
