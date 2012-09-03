module ErpHelper
  require 'rubygems'
  require 'syntax/convertors/html'
  require 'rexml/document'
  
  # convert xml to html and source highlight
  # dependency gems: syntax >= 1.0.0
  # sudo gem install syntax
  def self.xml2html(xml = '')
    xml = '' if xml.blank?
    begin
      convertor = Syntax::Convertors::HTML.for_syntax('xml') 
      return convertor.convert(xml)
    rescue => ex
      xml2html_regex(xml)
    end
  end
  
  def self.xml2html_regex(xml = '')
    xml = '' if xml.blank?
    begin
      html = "<pre>"
      html << xml.gsub(/&/, "&amp;").gsub(/</, "&lt;").gsub(/>/, "&gt;").gsub(/"/, "&quot;")
      html << "</pre>"
      return html
    rescue
      return "<pre>Convert xml to html false.</pre>"
    end
  end

  # check that an XML document if will formed
  # reformat xml for easy human read
  def self.tidy_xml(xml = '')
    xml = '' if xml.blank?
    begin
      result = ''
      REXML::Document.new(xml).write(result, 0)
      return result
    rescue REXML::ParseException
      return "Parse XML false."
    end
  end
  
  #==============================================
  # Rounding float to two decimal place
  # (default precision is 2)
  # e.g.
  #   roundf(1.234) #=> 1.23
  #   roundf(1.235) #=> 1.24
  #==============================================
  def self.roundf(number, precision=2)
    return ((number * (10 ** precision)).round.to_f) / (10 ** precision)
  end
  
  # render pass in message and print it with color :)
  def self.logger(message, color = nil)
    case color
    when 'red'    : color = '31;1'
    when 'green'  : color = '32;1'
    when 'yellow' : color = '33;1'
    when 'blue'   : color = '34;1'
    when 'purple' : color = '35;1'
    when 'sky'    : color = '36;1'
    else color = '36;1'
    end
    print "\e[#{color}m#{message}\e[0m\n" 
  end  
end