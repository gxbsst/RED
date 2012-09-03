class EmailAnnouncement < ActiveRecord::Base
  validates_presence_of :name, :message => _('GLOBAL|MESSAGE|EMPTY_FIRST_NAME')
  validates_uniqueness_of :email_address, :message => _('GLOBAL|MESSAGE|EMAIL_ALREADY_EXISTS')
  validates_format_of :email_address, :with => /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})$/, :message => _('GLOBAL|MESSAGE|INVALID_EMAIL')
end
