# Acts As Manageable Log
# This acts provides Manageable Log functionality.
# Note:
#   This asts *DO NOT AFFECT UPDATING*
#
# TODO:
#   1. Detect accessor methods while loading class.
require 'manageable_logs'

module Hozaka
  module Acts
    module ManageableLog
      
      # Base Module for "Acts As Manageable Log"
      # Include this module to ActiveRecord::Base to extend this new feature.
      # Using as plugin, refer to init.rb
      module Base
        # Extend base class to implement this feature.
        def self.included( base )
          base.extend( ClassMethods )
        end
        
        # Class Methods
        module ClassMethods
          @@methods_mapping = {}
          
          # The only parameter "methods_mapping" used to do mapping methods into uniform. If you skip it, "MethodNotBeenImplement"
          #   will be raised while you calling the uniform accesor methods.
          # 
          # Example for using acts_as_manageable_log, if you want to get the raw_input in the logs, calling the uniform method "input"
          #   instead of attribute accessor "raw_input"
          # <code>
          # class MyLog < ActiveRecord::Base
          #   acts_as_manageable_log :input => :raw_input
          # end
          # </code>
          def acts_as_manageable_log( methods_mapping={} )
            ManageableLogs.register( self )
            @@methods_mapping = methods_mapping
          end
          
          # Find log records with mapped attributes.
          # Example for finding all event logs created by a client with IP: 12.12.12.12
          # <code>
          # UserEventLog.find_by_accessor :all, :remote_ip => "12.12.12.12"
          #   #=> SELECT * FROM user_event_logs WHERE ip_address = '12.12.12.12'
          # </code>
          # That' all :)
          #
          # TODO:
          #   1. Implement the order clause as extra option
          def find_by_accessor( sig, conditions={} )
            finder = (sig == :all) ? :find_all : :find_first
            
            # Contructing find conditions
            fields, values = [], []
            conditions.each do |key, value|
              fields << actual_method( key )
              values << value
            end
            options = { :conditions => construct_conditions_from_arguments( fields, values ) }
            
            send( finder, options[:conditions] )
          end
          
          # Return the actual method after methods mapping
          def actual_method( method_id )
            return( @@methods_mapping[method_id] || method_id )
          end
          
        end # end of class methods
        
        # Detecting Accessor Methods
        # Raise Implement Exception if any accessor has not been implemented.
        def method_missing( method_id )
          case original_method_id = self.class.actual_method( method_id )
            when Symbol
              send( original_method_id )
            else
              super( method_id )
          end
        end
        
      end # end of base module
      
      
      # Uniform Accessor Methods
      # *ALL* of these methods *MUST* be implemented.
      ACCESSOR_METHODS = [:account_num, :red_one_serial_num, :sales_id, :email_address, :first_name, :last_name, :company_name]
      
      # Exception
      class MethodNotBeenImplement < Exception; end
      
    end # end of ManageableLog
  end
end