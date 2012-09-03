class Download < ActiveRecord::Base
  belongs_to :download_category
  
  # Defined upload file path as constant
  UPLOAD_PATH = File.join(RAILS_ROOT,"downloads")
  
  # Validation begin here.
  validates_presence_of :version_major,    :message => "MajorVersion can't empty!"
  validates_presence_of :version_minor,    :message => "MinorVersion can't empty!"
  validates_presence_of :version_revision, :message => "RevisionVersion can't empty!"
  
  def validate
    errors.add(:windows, "Must select one platform at least!") if !windows && !mac
    errors.add(:file, @file_error) if @file_error
  end
  
  # save upload files.
  def file=(file)
    if file.size == 0
      @file_error = "Upload file size is zero or not exist."
    else
      File.open(File.join(UPLOAD_PATH, file.original_filename), "wb+") do |f|
        f.write(file.read)
        self[:filename] = file.original_filename
        self[:filesize] = file.size
      end
    end
  rescue
    @file_error = "Upload file exception."
  end
  
  def version
    return "#{version_major}.#{version_minor}.#{version_revision}"
  end
  
  def display_version
    pattern = self.download_category.display_pattern
    return "v#{version}" if pattern.blank?
    
    regex_patteres = [
      [/\$TITLE/, "#{self.download_category.title}"],
      [/\$VERSION/, version],
      [/\$BUILD/, "#{build_number}"],
      [/\$DATE/, "#{release_date}"]
    ].each do |regex|
      pattern.gsub!(regex.first, regex.last)
    end
    
    return pattern
  end
  
  def size_in_megabytes
    filesize.to_f / (1024 ** 2)
  end
  
  # Get platform message.
  #   e.g.
  #   ["windows", "mac"]
  def platform
    result = []
    result << "windows" if windows
    result << "mac" if mac
    return result
  end
  
  def all_platform_available?
    windows && mac
  end
  
  # Return the latest agreement version of this download category.
  def agreement
    if download_category.agreement
      return download_category.agreement.latest_version
    end
  end
end
