# Class for binding variables for generating mail conent.
require 'mail_tasks/render/template_helper'

module MailTasks
  module Render
    class Binder
      include TemplateHelper
      include ActionView::Helpers::NumberHelper
      
      # Intialize a binder, with variables passed as Hash
      #
      #   MailTasks::Binder.new(
      #     :base => "http://www.red.com",
      #     :post_back_url => "/post_back",
      #     :variables => { :a => "a", :b => "b" }
      #   )
      def initialize( variables={} )
        variables.each do |key, value|
          self.instance_variable_set( "@#{key}", value.dup ) # dump each value preventing dirty-save.
        end
      end
      
      # Return binding object
      def get_binding
        self.send :binding
      end
      
    end
  end
end