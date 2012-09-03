module GetText
  class Writer
    include Utils
    
    # Save entities (as an Array) into po file.
    #   nodes = [['Key 1', 'Value 1'], ['Key 2', 'Value 2']]
    # and target file looks like
    #   msgid "Key 1"
    #   msgstr "Value 1"
    #   
    #   msgid "Key 2"
    #   msgstr "Value 2"
    def write( language, nodes )
      FileUtils.makedirs( File.join(@root, language) )
      File.open( file_name(language), 'w+' ) do |file|
        entities = nodes.map { |node| parse_node(node.first, node.last) }
        file << entities.join("\n\n")
      end
    end
    
    private
    
    def parse_node( msgid, msgstr )
      return ["msgid \"#{encode(msgid)}\"", "msgstr \"#{format_message(msgstr)}\""].join("\n")
    end
    
    # Format message lines.
    def format_message( message )
      return encode(message||"")
    end
  end
end