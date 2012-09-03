class Ip2addressForChina < ActiveRecord::Base

  # Database Connection Configuration
  # IP address database is stored by SQLite3 in current version.
  set_table_name "ip2address_local"

  require 'sqlite3'
  self.establish_connection(
    :adapter => 'sqlite3',
    :database => AppConfig.IP_FOR_CHINA_DATABASE
  )
  
  # Return a record in for given ip address.
  # NOTE:
  # Parameter 'ip_address' should in form like this: 127.0.0.1
  def self.find_location_by_ip(ip_address)
    ip_number = calc_ip_number(ip_address)
    
    find :first, :conditions => ['? BETWEEN ipFrom AND ipTo', ip_number]
  end
  
  # Compatible method for Daniel.
  def self.find_location(ip_address)
    find_location_by_ip(ip_address).attributes.values_at('countryLONG', 'ipREGION', 'ipCITY').join(', ')
  end
  
  # Convert ip_address to ip_number
  def self.calc_ip_number(ip_address)
    ip_number = 0
    ip_array = ip_address.split('.').reverse
    ip_array.each_index do |i|
      ip_number += ip_array[i].to_i * (256 ** i)
    end
    
    return ip_number
  end
end