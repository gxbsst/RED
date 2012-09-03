class InitializeDownloadCategoryPosition < ActiveRecord::Migration
  def self.up
    # prepare for sort, initialize download_categories position number.
    DownloadCategory.find(:all).each do |download_category|
      download_category.insert_at
    end
  end

  def self.down
  end
end
