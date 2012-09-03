class DownloadCategory < ActiveRecord::Base  
  VERSION_ORDER_CLAUSE = 'release_date DESC, build_number DESC, version_major DESC, version_minor DESC, version_revision DESC'
  PICTURE_DIR = %w(public skin img support)
  
  # register method to before_update callback chain when update.
  before_update :rename_picture
  
  #sortable download_category
  acts_as_list
  
  has_many :downloads, :order => VERSION_ORDER_CLAUSE
  belongs_to :agreement
  
  validates_presence_of :title, :message => "Title can't empty!"
  validates_presence_of :code,  :message => "Code Can't empty!"
  
  def validate
    errors.add(:picture, @picture_error) if @picture_error
  end

  def picture=(picture)
    case
    when picture.size == 0
      @picture_error = "Upload file size is zero or not exist."
    when !picture.content_type.match(/^image\/.+/)
      @picture_error = "Upload file type error, accept image only."
    else
      File.open(File.join(PICTURE_DIR, code2filename(code)), "wb+") do |f|
        f.write(picture.read)
      end
    end
  rescue
    @picture_error = "Upload file exception."
  end
  
  # return an array include all available platrorm about this DownloadCategory
  #   e.g.
  #   ["windows", "mac"]
  def available_platform
    downloads.collect(&:platform).flatten.uniq
  end
  
  # Support for generate picture filename by download code.
  #   code2filename("QuickTime Plugin")
  #   => "quicktime_plugin.png"
  def code2filename(code, ext = "png")
    result = []
    code.gsub(' ', '_').each_char do |char|
      result << char unless char.match(/[^\d\w]/)
    end
    return result.join.downcase << ".#{ext}"
  end
  
  # download category's picture absolute path.
  def picture_path
    File.expand_path(File.join(PICTURE_DIR, code2filename(code)))
  end
  
  # download category's picture relatively url.
  def picture_url
    File.join("/", PICTURE_DIR[1,3], picture_exists? ? code2filename(code) : "coming_soon.png")
  end
  
  # ruturn true if download picture exists.
  def picture_exists?(path=nil)
    path ||= picture_path
    File.exist? path
  end
  
  private
  
  # rename picture name when update download_category code  
  # register on before_update callback filter chain.
  def rename_picture
    previous_picture_path = DownloadCategory.find(self.id).picture_path
    if previous_picture_path && picture_exists?(previous_picture_path) && previous_picture_path != picture_path
      begin
        File.rename(previous_picture_path, picture_path)
      rescue
        # Do Nothing.
      end
    end
  end

end
