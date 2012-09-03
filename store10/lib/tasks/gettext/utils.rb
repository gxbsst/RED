module GetText
  module Utils
    ESCAPING = [
      ["\t", '\t'],
      ["\n", '\n'],
      ['"', '\"']
    ]
    
    def initialize( text_domain, root='po' )
      @file_name = text_domain << '.po'
      @root = root
    end
    
    private
    
    # Return the full file path
    def file_name( language )
      File.join( @root, language, @file_name )
    end
    
    def encode( string )
      s = string.dup
      ESCAPING.each { |rule| s.gsub!( rule.first, rule.last ) }
      return s
    end
    
    def decode( string )
      s = string.dup
      ESCAPING.each { |rule| s.gsub!( rule.last, rule.first) }
      return s
    end
  end
end