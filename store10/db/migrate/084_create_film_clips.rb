class CreateFilmClips < ActiveRecord::Migration
  def self.up
    create_table :film_clips do |t|
      t.column 'account_num',       :string, :limit => 16
      t.column 'email',             :string, :limit => 128
      t.column 'name',              :string, :limit => 64
      
      t.column 'title',             :string
      t.column 'studio',            :string, :limit => 64
      t.column 'producer',          :string, :limit => 64
      t.column 'director',          :string, :limit => 64
      t.column 'dp',                :string, :limit => 64
      t.column 'camera_sn',         :string, :limit => 64
      t.column 'lenses_used',       :string, :limit => 64
      t.column 'film_type',         :string
      t.column 'summary',           :text
      t.column 'release_date',      :date
      t.column 'website_url',       :string
      t.column 'trailer_url',       :string
      t.column 'actual_footage_url',:string
      t.column 'cast',              :string
      
      t.column 'authorized',        :boolean, :null => false, :default => false
      t.column 'sticked',           :boolean, :null => false, :default => false
      t.column 'position',          :integer
      
      # Handling thumbnail images for film clips via PaperClip plugin. Refer
      # to "PaperClip on Thoughtbot":http://thoughtbot.com/projects/paperclip
      t.column 'thumbnail_file_name', :string
      t.column 'thumbnail_content_type', :string
      t.column 'thumbnail_file_size', :integer
      t.column 'thumbnail_updated_at', :datetime
      
      t.column 'created_at', :datetime
      t.column 'updated_at', :datetime
    end
    
    add_index :film_clips, :account_num
  end

  def self.down
    remove_index :film_clips, :account_num
    drop_table :film_clips
  end
end
