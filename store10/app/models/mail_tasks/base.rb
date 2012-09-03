# Mail Tasks
# by Jerry.Guo <hozaka@gmail.com>
module MailTasks
  # Extentions
  module Base
    def self.included( klass )
      # Models uses the same connection
      klass.connection = DBConnection.connection
      klass.extend( ClassMethods )
    end
    
    module ClassMethods
      def find_or_new( id )
        find_by_id( id ) || new
      end
    end
  end
end