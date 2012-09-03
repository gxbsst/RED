require 'contact/rt/fields'
require 'contact/rt/request'

module Contact
  class Ticket < ActiveRecord::Base
    include Rt::FieldsAccessors
    include Rt::Submitable
    
    attr_accessor :attachment
    attr_protected :submitted, :uuid
    validates_presence_of :queue, :message => "hasn't been selected"
    validates_presence_of :name, :email, :subject, :content,
      :message => "can't be blank"
    
    # Provide UUID instead of record id for security.
    def to_params
      return self.uuid
    end
    
    # Geneatre an UUID for new ticket
    def before_create
      self.uuid = UUID.random_create.to_s
    end
    
    def validate
      if self.queue == 'TechSupport'
        errors.add(:serial_numbers, "can't be blank") if serial_numbers.blank?
        validate_attachment
      else
        attachment = nil # attachcment is not available for other queues
      end
    end
    
  private
    def validate_attachment
      return unless attachment.respond_to?(:read) && attachment.size > 0
      
      if attachment.size > 8.megabytes
        errors.add(:attachment, 'must be less than 8MB')
      end
      
      if File.extname(attachment.original_filename) != '.log'
        errors.add(:attachment, 'should be .log file')
      end
    end
  end
end
