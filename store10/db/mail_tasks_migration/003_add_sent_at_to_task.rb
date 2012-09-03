class AddSentAtToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :sent_at, :datetime
  end
  
  def self.down
    remove_column :tasks, :sent_at
  end
end