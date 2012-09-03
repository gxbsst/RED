module GetText
  module Db
    
    # Support languages.
    class Language < ActiveRecord::Base
      include Base
      
      has_many :revisions, :include => 'entity', :group => 'entity_id',
        :order => 'revision desc'
      has_many :completions, :class_name => "GetText::Task::Completion",
        :conditions => "completed = false", :order => "created_at DESC",
        :include => "task"
      
      # Find revisions in current language with a filter given in options as
      # SQL condition.
      def revisions_with( options={} )
        conditions = ["language_id = #{self.id}"]
        conditions << self.class.sanitize(options[:conditions]) if options[:conditions]
        conditions << "revision <= #{options[:revision]}" if options[:revision]
        
        sql = [
          'SELECT revisions.*, entities.name',
          'FROM revisions',
          'LEFT OUTER JOIN entities ON entities.id = revisions.entity_id',
          "WHERE #{conditions.join(' AND ')}",
          'GROUP BY entity_id',
          'ORDER BY name, revision DESC'
        ].join(' ')
        return self.class.find_by_sql(sql)
      end
      
      # Using language name as parameter in generating URL
      def to_param
        return self.name.to_s
      end
      
      private
      
      def self.sanitize( conditions )
        sanitize_sql( conditions )
      end
    end
    
  end
end