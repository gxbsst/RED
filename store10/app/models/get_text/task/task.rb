module GetText
  # GetText::Task is a collection of models that will help your team to manage
  # translation entities.
  # 
  # For Example, you added a new entity on website named "About Us" and
  # translated it into English. After that you want to tell others that you've
  # added this entity, they should translate it into other languages.
  #
  # What you need to do is just create a task for this entity with description,
  # that's all.
  module Task
    
    # Task Summary contains name, description.
    class Task < ActiveRecord::Base
      include Base
      
      validates_presence_of :name
      has_many :completions
      
      # Create completions for this task.
      def after_create
        GetText::Db::Language.find(:all).each do |lang|
          self.completions.create(:language => lang)
        end
      end
    end
    
  end
end