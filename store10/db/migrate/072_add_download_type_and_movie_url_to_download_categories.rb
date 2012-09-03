class AddDownloadTypeAndMovieUrlToDownloadCategories < ActiveRecord::Migration
  
  def self.up
    add_column :download_categories, :download_type,  :string
    add_column :download_categories, :movie_url,      :string
    add_column :download_categories, :movie_size,     :string
    add_column :download_categories, :movie_duration, :string
  end

  def self.down
  
    remove_column :download_categories, :download_type
    remove_column :download_categories, :movie_url
    remove_column :download_categories, :movie_size,     :string
    remove_column :download_categories, :movie_duration, :string
    
  end
end
