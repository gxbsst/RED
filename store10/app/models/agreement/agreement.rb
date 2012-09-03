class Agreement < ActiveRecord::Base
  has_many :agreement_versions, :order => 'version DESC'
  has_one :latest_version, :class_name => 'AgreementVersion', :order => 'version DESC'
  validates_presence_of :name
end
