# Logs Manager
class ManageableLogs
  
  LOG_TYPES = {}
  
  # Register given model as a Manageable Log
  def self.register( klass )
    LOG_TYPES.merge!( klass.name => klass )
  end

  def self.[]( klass_name )
    unless LOG_TYPES.keys.include?( klass_name )
      raise ActiveRecord::RecordNotFound, "#{klass_name} is not registered as ManageableLog"
      return false
    end
    
    return LOG_TYPES[klass_name]
  end

end