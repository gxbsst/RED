module Contact
  module Rt
    SETTINGS = YAML.load_file(File.join(RAILS_ROOT, 'config', 'rt.yml')).freeze
    
    # Convert ticket attributes into customized fields defined in RT server.
    class Fields
      def self.build(ticket)
        fields = SETTINGS['default_fields'].dup
        SETTINGS['attributes_to_fields'].each do |name, method|
          fields[name] = ticket.send(method.to_sym)
        end
        return fields
      end
    end
    
    # Accessor methods required for convertion.
    module FieldsAccessors
      def requestor
        "#{name} <#{email}>"
      end
      
      # The actual queue name set up in RT server, depends on ticket's language.
      def rt_queue
        return(self.lang == 'en_US' ? queue : self.lang)
      end
      
      def rt_serials
        return(self.serial_numbers.split(',').map(&:strip))
      end
      
      def rt_fields
        Rt::Fields.build(self)
      end
    end
  end
end
