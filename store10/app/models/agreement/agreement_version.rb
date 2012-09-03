class AgreementVersion < ActiveRecord::Base
  belongs_to :agreement
  validates_presence_of :content, :message => "content can't empty!"
end
