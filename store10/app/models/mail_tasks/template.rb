require 'mail_tasks/render/base'

module MailTasks
  class Template < ActiveRecord::Base
    include Base
    
    # Vaidations
    validates_presence_of :name, :subject, :body, :from
    
    # Variables defined in template with default values
    serialize :variables, Hash
    
    # Render the mail content within layout for preview
    def content_for_preview( layout_options )
      content = self.body.dup
      content.gsub!( /<%=\s?(@[^%]+)\s?%>/, '<code>\1</code>' )
      mail = Mail.new( :token => "" )
      mail.content = Render::Base.new( content ).mail_content
      template = IO.read("#{RAILS_ROOT}/app/views/mail_tasks/mailer/this_mail.text.html.rhtml")
      
      render = Render::Base.new( template, layout_options.merge( :mail => mail ) )
      render.mail_content
    end
    
    # Detect variable keys from template body (both inline template & pre-set template)
    # 
    #   template_body = "<%= @variables['key1'] %>, <%= @variables['key2'] %>"
    #   MailTasks::Template.detect_variables( template_body )
    #   #=> { "key1" => nil, "key2" => nil }
    def self.detect_variables( template_body )
      variables = {}
      template_body.scan( /\@variables\[['"]([^'"]+)["']\]/ ) { |key| variables.merge!( $1 => nil ) }
    rescue
      # do nothing
    ensure
      return variables
    end
    
    # Realtime template variables.
    # If template body has been modified, this methods returns a new Hash contains variables used in
    # the new template with original default value if exists with same key.
    #
    #   template = MailTasks::Template.find(1)
    #   pp template.body
    #     #=> "<%= @variables[:existed_variable] %>"
    #   pp template.variables
    #     #=> { "existed_variable" => "default_value_1" }
    #   template.body << "<%= @variables[:new_variables] %>"
    #   pp template.variables
    #     #=> { "existed_variable" => "default_value_1", "new_variables" => nil }
    def variables
      template_variables = self.class.detect_variables( self.body )
      template_variables.each do |key, value|
        template_variables[key] = (self.attributes["variables"]||{})[key]
      end
      return template_variables
    end
    
  end
end