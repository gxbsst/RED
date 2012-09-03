class Image < ActiveRecord::Base
  has_and_belongs_to_many :products, :order => 'sort_order DESC'
  file_column :path, :magick => { :versions => { "thumb" => "65x65", "big" => "305x305", "small" => "150x111>" } }
end
