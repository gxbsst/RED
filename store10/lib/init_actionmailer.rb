module ActionMailer
  class Base
    private
    def initialize_defaults(method_name)
      @charset ||= @@default_charset.dup
      @content_type ||= @@default_content_type.dup
      @implicit_parts_order ||= @@default_implicit_parts_order.dup
      @template ||= method_name
      @mailer_name ||= Inflector.underscore(self.class.name)
      @parts ||= []
      @headers ||= {
        'X-Server-Hostname' => Socket::gethostname(),
        'X-Process-Name' => $0,
        'X-Rails-Environment' => ENV['RAILS_ENV']
      }
      @body ||= {}
      @mime_version = @@default_mime_version.dup if @@default_mime_version
    end
  end
end