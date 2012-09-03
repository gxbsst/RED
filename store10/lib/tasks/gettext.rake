%w{utils parser writer}.each { |f| require "lib/tasks/gettext/#{f}"}

namespace :gettext do
  # Change the comming line to change another directory if you need.
  MIGRATION_SCRIPT_ROOT = "db/gettext/migrate"
  
  # Database migration
  desc "Migrate database / tables as GetText database storage."
  task :migrate => :environment do
    ActiveRecord::Base.establish_connection :gettext
    ActiveRecord::Migrator.migrate(
      MIGRATION_SCRIPT_ROOT,
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end
  
  # Rebuild all records from ".po" files. Normally, this task should be called to initialize the
  # database.
  # Note:
  # Calling this task will DELETE EXISTING RECORDS in current database. It's recommended that back
  # up the database before all.
  desc "Rebuild gettext database and all records via original \".po\" files."
  task :rebuild_database => :environment do
    # Disable "after_create" callback
    GetText::Db::Entity.class_eval <<-EOF
      def after_create
        puts "[callback] created entity: " << self.name
      end
    EOF
      
    parser = GetText::Parser.new('red')
    languages = GetText::Db::Language.find(:all)
    @entities = {}
    
    # Initialize entity keys
    languages.each do |language|
      nodes = parser.parse(language.name)
      next if nodes.empty?
      
      puts "Building entities for language: #{language.name} "
      nodes.each do |node|
        entity = node.first
        GetText::Db::Revision.create(
          :language => language,
          :entity => (
            @entities[entity] ||= GetText::Db::Entity.create(:name => entity)
          ),
          :text => node.last
        )
      end
    end
  end
  
  desc 'Create ".po" files using translation entities saved in database.'
  task :make => :environment do
    writer = GetText::Writer.new('red')
    revisions_group = GetText::Db::Revision.find(
      :all,
      :include => 'entity',
      :conditions => ['deleted = ?', false],
      :order => 'name'
    ).group_by(&:language_id)
    
    revisions_group.each do |language_id, revisions|
      language = GetText::Db::Language.find(language_id)
      puts "Building template files for language: #{language.name}"
      nodes = revisions.map { |revision| [revision.entity.name, revision.text] }
      writer.write(language.name, nodes)
    end
  end
  
  desc 'Compile translation entities into ".mo" files that could be used by website.'
  task :publish => :make do
    GetText.create_mofiles( true, 'po', 'locale' )
  end
end