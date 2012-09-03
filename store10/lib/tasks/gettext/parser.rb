module GetText
  class Parser
    include Utils
    
    def initialize( text_domain, root='po' )
      @file_name = text_domain << '.po'
      @root = root
    end
    
    # Parse ".po" file and return an Array in which contains id-translation pairs.
    #   parser = GetText::Parser.new('red')
    #   parser.parse('en_US') # parsing file "po/en_US/red.po"
    #   # => ["Message Id", "Message Content"]
    def parse( language, target=[] )
      file = file_name(language)
      content = File.open( file, 'r' ).read.gsub( /\"\n\"/, '' )
      puts "Parsing \"#{file}\" ..."
      content.each_line do |line|
        parse_line( line, target ) unless line.first == '#'
      end
      target.shift # remove po header
      
      return target
    rescue Errno::ENOENT
      puts "Can not found \"#{file}\", parsing skipped."
      return []
    end
    
    private

    def parse_line( line, target )
      if line =~ /^msgid \"(.*)\"$/
        target << [$1]
      elsif line =~ /^msgstr \"(.*)\"$/
        target.last << decode($1)
      elsif line =~ /\"(.*)\"/
        target.last.last << decode($1)
      end
    end
    
  end
end