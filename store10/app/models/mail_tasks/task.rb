require 'digest'
require 'mail_tasks/render/base'

module MailTasks
  class Task < ActiveRecord::Base
    include MailTasks::Base
    
    # Associations
    has_many :mails
    belongs_to :template
    
    # Validations
    # validates_presence_of :name, :recipients
    # validates_presence_of :subject, :from, :template_body, :if => :inline_template?
    
    # Additional Attribute Accessor
    attr_accessor :recipients
    
    # Customizable runtime variables
    serialize :variables, Hash
    
    # Generate mails for users given as parameter.
    # By default, mails will be saved to database after generated unless params "do_save_mails" is "false"
    # Contains a image tag for posting back a request to 'post_back_url' while opening
    #   this mail in order to mark mail as "READED".
		def generate_mails( contacts, do_save_mail = true, layout_options={} )
			self.class.transaction do
				contacts.each do |contact|
					mail = self.mails.build(
					:email => contact.email,
					:first_name => contact.first_name,
					:last_name => contact.last_name,
					:company_name => contact.company_name,
					:account_num => contact.account_num,
					:sales_id => contact.sales_id,
					:token => contact.token,
					:content => contact.content,
					:rep_email => contact.rep_email,
					:created_at => contact.created_at,
					:updated_at => contact.updated_at,
					:read_at => contact.read_at,
					:sent_at => contact.sent_at,
					:name => contact.name
					)
					mail.save! if do_save_mail
				end
			end
		end
    
    # Return template body in String
    def get_template
      template.nil? ? self.template_body : template.body
    end
    
    # Additional validation to mail task, including
    # * Template Variables
    def validate
      self.variables.each do |key, value|
        self.errors.add(
          :variables,
          "<tt>#{key}</tt> can't be blank"
        ) if value.blank?
      end
    end
    
    # Overwrite the reader method of attribute "variables", return an empty Hash as default
    #   if anything unexcepted.
    def variables
      if self.template.nil?
        template_variables = Template.detect_variables( self.get_template )
      else
        template_variables = self.template.variables
      end
      original_variables = self.attributes["variables"] || {}
      original_variables.each do |key, value|
        template_variables[key] = value if template_variables.keys.include?( key )
      end
      return template_variables
    end

    private
    
    # Return true if task do not use any existing template.
    def inline_template?
      if template_id.blank? || template_id.zero?
        return true
      else
        return false
      end
    end
    
  end
end