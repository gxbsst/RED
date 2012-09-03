module GetText
  module Task
    
    # Task status.
    class Completion < ActiveRecord::Base
      include Base
      
      belongs_to :task
      belongs_to :language, :class_name => "GetText::Db::Language"
    end
    
  end
end