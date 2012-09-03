module GetText
  # GetText Database Storage Version
  # Author:  Jerry Guo <hozaka@gmail.com>
  # 
  # GetText::Db provides another storage that you can choice besides original
  # "po" files. In additional, a friendly designed tools is also available in
  # this package that users could manage all translation entities (including
  # managing, translating, etc.) with.
  module Db
    
    # Key of an translation entity.
    class Entity < ActiveRecord::Base
      include Base

      validates_presence_of :name
      validates_uniqueness_of :name
      
      has_many :revisions, :include => "language"
      has_many :tasks, :class_name => "GetText::Task::Task"
      
      # Find entity's revision in specified language.
      #   entity = GetText::Db::Entity.find(1)
      #   revision = entity.in_language('en_US')
      def in_language( language )
        raise("Deprecated!")
        lang = GetText::Db::Language.find_by_name(language)
        self.revisions.find_by_language_id(lang.id) ||
          raise(ActiveRecord::RecordNotFound)
      end
      
      def after_create
        GetText::Db::Language.find(:all).each do |lang|
          self.revisions.create( :language => lang, :text => self.text )
        end
      end
    end
    
  end
end