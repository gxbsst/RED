module GetText
  # Global class that will be included for classes.
  module Base
    # Using indenpendent database connection.
    def self.included(klass)
      klass.establish_connection :gettext
    end
  end
end