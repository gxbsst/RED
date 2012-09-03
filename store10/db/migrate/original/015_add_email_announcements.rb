class AddEmailAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :email_announcements do |t|
      t.column 'name', :string, :null => false
      t.column 'email_address', :string, :null => false
      t.column 'industry', :string
      t.column 'editor', :string
      t.column 'system', :string
      t.column 'comments', :text
      t.column 'hd_camera', :string
      t.column 'raw_camera', :string
    end
  end

  def self.down
    drop_table :email_announcements
  end
end
