module  MailTasksW1
  module Base
    def self.included( klass )
      klass.connection = DBConnection.connection
    end
  end
end