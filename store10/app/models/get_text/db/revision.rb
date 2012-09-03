module GetText
  module Db
    
    # Translated content of an entity.
    class Revision < ActiveRecord::Base
      include Base
      
      belongs_to :entity
      belongs_to :language
                  
      # Instead of calling "save" directly, you should use this method to
      # create a new revision of translation entity if you want. Only in this
      # case "Traceable Revisions" is available.
      # TODO:
      # Overwrite the method "save" if record is now newly created?
      def new_revision(attrs)
        return self.class.new(
          attrs.merge(:entity => self.entity, :language => self.language)
        )
      end
      
      def completions
        return GetText::Task::Completion.find(
          :all,
          :include => "task",
          :conditions => [
            "completed = ? AND entity_id = ? AND language_id = ?",
            false, self.entity_id, self.language_id
          ],
          :order => "created_at DESC"
        )
      end
      
      # Use entity's default text content if blank.
      def text
        original_text = super
        return( original_text.blank? ? entity.text : original_text )
      end
    end
    
  end
end