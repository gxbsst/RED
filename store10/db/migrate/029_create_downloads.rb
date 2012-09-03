class CreateDownloads < ActiveRecord::Migration
  def self.up
    create_table :downloads do |t|
      t.column :download_category_id,  :integer
      t.column :name,                  :string
      t.column :version_major,         :integer
      t.column :version_minor,         :integer
      t.column :version_revision,      :integer
      # Platform can be 'win32' or 'mac'
      t.column :windows,               :boolean
      t.column :mac,                   :boolean
      #t.column :linux,                 :boolean
      t.column :release_note,          :text
      t.column :release_date,          :date
      t.column :filename,              :string
      t.column :filesize,              :integer
      t.column :created_at,            :datetime
    end
    
    create_table :download_categories do |t|
      t.column :title,        :string, :null => false
      t.column :description,  :text
    end
    
    # Add new column in store_users for distinguish purchased client.
    add_column :store_users, :purchased, :boolean, :null => false, :default => false
    
    # Add new role and right for Downloads admin tools.
    Role.find(1).rights << Right.create(:name => 'Downloads', :controller => 'downloads', :actions => '*')
  end

  def self.down
    drop_table    :downloads
    drop_table    :download_categories
    remove_column :store_users,  :purchased
    
    Role.find(1).rights.delete(Right.find_by_controller('downloads'))
    Right.find_by_controller('downloads').destroy
  end
end
