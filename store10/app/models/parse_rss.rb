##################################################
#get news rss power by weston
#agxbsst@gmail.com
##################################################
class ParseRss 
  require 'rubygems'
  require 'xml/libxml'
  require 'open-uri'
  class NewsRss 
    attr_accessor :title, :link,:description
  end
  class BaseNewsParser
    def initialize(filename)
      content= open(filename)
      #@raw_xml = content.read
      #filename = XML::Parser.string(feed).parse
      # @raw_xml = File.open(filename).read
      @news = []
    end
  end
  class LibXMLNewsParser < BaseNewsParser
    def initialize(filename)
      #initialize XML DOCUMNET
      super
      content= open(filename)
      feed = content.read
      filename = XML::Parser.string(feed).parse
      @filename = filename
    end
    def get_news_rss
      doc = @filename
      doc.find('//rss/channel/item').each do |node|
        news_rss = NewsRss.new
        news_rss.link = node.find('link').to_a.first.content
        news_rss.title = node.find('title').to_a.first.content
        news_rss.description = node.find('description').to_a.first.content
=begin
        for address in node.find('addresses/address').to_a
          new_address = Address.new
          new_address.type = address['type']
          new_address.public = address['public']
          new_address.street = address.find('street').to_a.first.content
          new_address.city = address.find('city').to_a.first.content
          new_person.addresses << new_address
        end
=end
        @news << news_rss 
      end
      @news
    end
  end
end

