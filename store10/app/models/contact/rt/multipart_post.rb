require 'cgi'

module Contact
  module Rt
    class MultipartPost
      BOUNDARY = 'ticket-boundary'
      CONTENT_TYPE = "multipart/form-data; boundary=#{BOUNDARY}"
      
      class Param
        def initialize(key, value)
          @key, @value = key, value
        end
        
        def to_multipart
          return "Content-Disposition: form-data; name=\"#{@key}\"\r\n\r\n#{@value}\r\n"
        end
      end
      
      class FileParam
        def initialize(key, file)
          @key, @file = key, file
        end
        
        def to_multipart
         header = [
            "Content-Disposition: form-data; name=\"#{@key}\"; filename=\"#{@file.original_filename}\"",
            "Content-Type: #{@file.content_type}",
            "Content-Transfer-Encoding: binary"
          ].join("\r\n")
          
          return "#{header}\r\n\r\n#{@file.read}\r\n"
        end
      end
      
      def self.to_multipart(request, fields)
        entries = []
        fields.each do |key, value|
          if value.respond_to?(:read) # file entry
            entries << FileParam.new(key, value).to_multipart
          else
            entries << Param.new(key, value).to_multipart
          end
        end
        
        request.body = [
          entries.map { |entry| "--#{BOUNDARY}\r\n#{entry}" },
          "--#{BOUNDARY}--"
        ].join
        request.content_type = CONTENT_TYPE
        request.content_length = request.body.length
        
        return request
      end
      
    end
  end
end
