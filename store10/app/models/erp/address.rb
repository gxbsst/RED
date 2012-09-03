class ERP::Address < ActiveRecord::Base
  include ERPSupport
  
  # Validations
  # validates_format_of :state, :with => /^[A-Z]{2}$/, :if => Proc.new { |address| address.country_region_id == "US" }
  validates_format_of :country_region_id, :with => /[A-Z]{2}/
  
  # Return a full address string
  def full_address
    [street, city, state, zip_code].delete_if{ |content| content.blank? }.join(", ")
  end
  alias_method :summary, :full_address

  def handle
    return self.name + "..." unless name.blank?
    return self.street + "..." unless street.blank?
    return "<incomplete address>"
  end
  
  def before_destroy
    self.country_region_id = ""
  end

=begin
  def country=( country_name, dependent = true )
    super( country_name )
    if dependent
      country_ref = Country.find_by_name( country_name )
      # self.country_region_id=( country_ref.fedex_code, !dependent ) unless country_ref.nil?
      self.send( :country_region_id=, country_ref.fedex_code, false ) unless country_ref.nil?
    end
  end
  
  def country_region_id=( region_id, dependent = true )
    super( region_id )
    if dependent
      country_ref = Country.find_by_fedex_code( region_id )
      # self.country=( country_ref.name, !dependent ) unless country_ref.nil?
      self.send( :country=, country_ref.name, false ) unless country_ref.nil?
    end
  end
=end

  def before_save
=begin
    if self.country_region_id.nil? || self.country_region_id.empty?
      country = Country.find_by_name( self.country )
      self.country_region_id = country.fedex_code unless country.nil?
    end
=end

    # Hash the address
    self.hash = MD5.md5("#{street}#{city}#{state}#{zip_code}#{county}#{country_region_id}").to_s
  end
end
