module ErpLog
  class AxStoreUserLog < ActiveRecord::Base
    require 'digest'
    
    # Starting an conversation with AX ERP Server.
    # An unique token will be generaten in this method.
    def self.start(attributes, raw_input)
      return create(
        :email_address => attributes[:email_address],
        :raw_input => raw_input
      )
    end
    
    # While a message has been returned to the AX ERP Server,
    #   the message will be logged.
    def return(status, return_message, message=nil)
      update_attributes(
        :status => status,
        :message => message,
        :return_message => return_message
      )
    end
    
    # If an exception occured in conversation, this method is called by controller.
    def exception(exception)
      update_attributes(
        :status => 'EXCEPTION',
        :message => exception.to_yaml
      )
    end
  end
end