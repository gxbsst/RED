require 'uri'

class FilmClip < ActiveRecord::Base
  FILM_TYPES = ['', 'Movie', 'TV', 'DVD', 'TVC', 'Music Video', 'Documentary',
    'Other'].freeze
  
  # Handle the thumbnails of film clip.
  has_attached_file :thumbnail,
    :styles => { :small => '134x193>' },
    :default_style => :small,
    :url => '/images/film_clips/:id/:style.:extension',
    :path => ':rails_root/public/images/film_clips/:id/:style.:extension'
  
  validates_presence_of :summary, :title, :type, :thumbnail
  validates_exclusion_of :type, :in => FILM_TYPES
  
  attr_protected :authorized, :account_num, :email, :name
  
  # [PATCH]
  # 
  # Since Safari will post an empty string but String IO with Firefox will
  # no uploading specified, it cause a problem that Paperclip will delete all
  # existing thumbnail files if no attachment is assigned while updating.
  # 
  # Detect this differenct and then skip the assignment process in right way.
  # 
  # Note:
  # Fixed in later Rails. Refer to "http://dev.rubyonrails.org/changeset/7759"
  # def thumbnail=(thumbnail)
  #   unless thumbnail.respond_to?(:size) && thumbnail.size == 0
  #     super(thumbnail)
  #   end
  # end
  

  def trailer_url_host
   self.trailer_url ? URI.parse(self.trailer_url).host : nil
  end
  
  def website_url_host
    self.website_url ? URI.parse(self.website_url ).host : nil    
  end
end
