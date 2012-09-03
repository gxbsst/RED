class WarrantyRegistration < ActiveRecord::Base
  validates_uniqueness_of :email_address,  :message => "is already being register"
  validates_presence_of :serial_number
  validates_length_of :email_address, :maximum => 255
#   validates_format_of :zip, :with=> /\d{6}/, :message => 'is invalid.'
  validates_format_of :email_address,
                        :with => /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/,
                        :message => "Please enter a valid email address."
end
