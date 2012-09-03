module ERP
  module ERPSupport
		include ERP::HelperMethods
    
    # Directory saving all xml tempaltes
    XML_TEMPLATES_DIR = "#{RAILS_ROOT}/app/models/erp/xml_templates"
    
    # Prefix of table name.
    def self.included(base)
      base.set_table_name "erp_" + base.table_name unless base.table_name =~ /^erp\_/
      base.extend ClassMethods
    end
    
    def sync
      raise "Implement this method in Module to synchronize data with remote AX server."
    end
    
    # Convert current instance to XML file.
    # Defaults:
    #   Template file name equals to class name, and variable name equals to template file name.
    def to_xml(assigns={})
      file_path = self.class.name.underscore
      self.class.generate_xml file_path, assigns.merge(File.basename(file_path).to_sym => self)
    end
    
    # Class Methods
    module ClassMethods
      
      # Generate an XML with the given template.
      # Note:
      #   The root element named "doc"
      def generate_xml(template, assigns={})
        # Bing objects given by "assigns" to instance variables.
        # So these instance variables are all accessible in .rxml templages.
        env = Object.new
        bind = env.send :binding
        assigns.each do |key, value|
          env.instance_variable_set "@#{key}", value
        end
        
        buffer = [] # Using an Array instead of String to enhance performance
        doc = Builder::XmlMarkup.new :target => buffer, :indent => 2
        
        # TODO:
        #   "eval" is not a good way to render XML template.
        eval IO.read(File.join(XML_TEMPLATES_DIR, template.to_s + ".rxml")), bind
        
        return IO.read(File.join(XML_TEMPLATES_DIR, "_layout.xml")).sub("<!-- @content -->", buffer.join)
      end
      
    end
  end
end
