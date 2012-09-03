# Manage, generate searching conditions for recipients filter
#   in creating mail recipients in specify scope.
module MailTasks
  
  # Condition Pattern
  class ConditionPattern
    
    def initialize( name, condition )
      @hash = condition.merge(
        "name" => name,
        "params" => condition["sql_clause"].scan(/\:([^\s]+)/).flatten - ["item_id"]
      )
    end
    
    def []( key )
      return @hash[key.to_s]
    end
    
  end
  
  # Exceptions
  class UnknownRecipientsCondition < Exception; end
  
  class RecipientsConditions
    CONFIGURATION = YAML.load_file( "#{RAILS_ROOT}/config/configurations/mail_tasks/recipients_conditions.yml" )
    PATTERNS = []
    CONFIGURATION.each do |name, condition|
      PATTERNS << ConditionPattern.new( name, condition )
    end
        
    # Append new condition that will be available to filter mail recipients
    # def self.append_condition( condition_name, pattern, params_count, type )
    #   PATTERNS << ConditionPattern.new( condition_name, pattern, params_count )
    # end
    
    # Generate condition clause
    # Receive a Array in this form:
    # 
    #   [
    #     { :condition_name => "Testing Condition1", :key1 => "value1", :key2 => "value2" },
    #     { :condition_name => "Testing Condition2", :key1 => "value1", :key2 => "value2" }
    #   ]
    def self.to_condition_clause( conditions )
      clauses = []
      conditions.dup.each do |condition|
        pattern = find_pattern( condition.delete( :condition_name ) )
        
        binding_values = condition[:values][0, pattern[:params_count] || 0]
        if (product_code = condition[:product_code] )
          binding_values.unshift( product_code )
        end
        
        clause = ActiveRecord::Base.send( :sanitize_sql, [pattern[:sql_clause]].concat(binding_values) )
        clauses << "(#{clause})"
      end
      
      return "(#{clauses.join(" OR ")})"
    end
    
    # Return recipients in condition
    # Params is same form as `to_condition'
    def self.get_recipients( conditions, additional_sql=nil )
      conditions_clause = self.to_condition_clause( conditions )
      
      recipients = StoreUser.find(
        :all,
        :include => "customer",
        :joins => [
          "JOIN erp_sales_orders ON erp_sales_orders.erp_customer_id = erp_customers.id",
          "JOIN erp_sales_lines ON erp_sales_lines.erp_sales_order_id = erp_sales_orders.id"
        ].join(" "),
        :group => "store_users.id",
        :conditions => ( additional_sql.nil? ? conditions_clause : [conditions_clause, additional_sql].join(" AND "))
      )
      
      return recipients
    end
    
    def self.group_by_type
      PATTERNS.group_by { |pattern| pattern[:type] }
    end
    
    private
    
    # Find condition pattern by name
    def self.find_pattern( condition_name )
      pattern = PATTERNS.find { |pattern| pattern[:name] == condition_name }
      raise( UnknownRecipientsCondition, "Unknown recipient condition '#{condition_name}'" ) unless pattern.is_a?( ConditionPattern )
      return pattern
    end
    
  end
end