require "digest/sha1"
class NewsAdminUser < ActiveRecord::Base
  validates_presence_of :name 
  validates_uniqueness_of :name 
  
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessible :password ,:name
  
  def validate_on_create
    errors.add(:password, "is incorrectly confirmed") if password != password_confirmation
  end

=begin
  def validate 
    errors.add_to_base("Missing password") if hashed_password.blank? 
  end 
  private 
  def self.encrypted_password(password, salt) 
    string_to_hash = password + "wibble" + salt # 'wibble' makes it harder to guess 
    Digest::SHA1.hexdigest(string_to_hash) 
  end 
  def create_new_salt 
    self.salt = self.object_id.to_s + rand.to_s 
  end 
=end
  before_destroy :dont_destroy_admin
  def dont_destroy_admin
    raise "Can't destroy the Super admin" if self.name == 'admin'
  end
  def before_create
    self.hashed_password = NewsAdminUser.hash_password(self.password)
  end
  def after_create
    @password = nil
  end

  def try_to_login
    NewsAdminUser.login(self.name,self.password)
  end
  private
  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
  def self.login(name,passord)
    hashed_password = hash_password(passord || "")
    find(:first,
         :conditions => ["name = ? and hashed_password = ?",name,hashed_password])
  end 
end
