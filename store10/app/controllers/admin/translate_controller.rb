module Admin
  # RED Translate Tools for managing all translation entities of website.
  # Models:
  # * Language - supported language
  # * Entity   - a place holder identified by name, translated content will
  #              diplay in this place
  # * Revision - translated content in specified language
  class TranslateController < BaseController
    before_filter :init

    def index
      @languages = GetText::Db::Language.find(:all)
    end
    
    # List translation entities in specified language given in params.
    # Optionally, you can also provided another params "letter" to find out
    # part of entities starting with it.
    def list
      if params[:keyword]
        name_pattern = "%#{params[:keyword]}%"
      else
        name_pattern = "#{params[:letter]}%"
      end
      
      @entities = GetText::Db::Entity.find(
        :all,
        :conditions => ['name like ?', name_pattern]
      )
    end
    
    def new
      @entity = GetText::Db::Entity.new
    end
    
    def create
      @entity = GetText::Db::Entity.new(params[:entity].merge(:lang => @lang))
      
      if @entity.save
        flash[:notice] = "Entity \"#{@entity.name}\" created."
        redirect_to :edit, :id => @entity
      else
        flash.now[:notice] = @entity.errors.full_messages.join('<br />')
      end
      redirect_to :back
    end
    
    def edit
      @revision = GetText::Db::Revision.find(
        :first,
        :include => "entity",
        :conditions => ["entities.id = ? and language_id = ?", params[:id], @lang.id],
        :order => "revision DESC" # TODO: specified revision num
      )
      @completions = @revision.completions
    end
    
    # Update the translation content of an entity.
    # TODO:
    # Create a new revision for this entity instead update attributes of
    # existing record.
    def update
      @revision = GetText::Db::Revision.find(params[:id], :include => "entity")
      
      if @revision.update_attributes(params[:revision])
        flash[:notice] = 'Translation has been saved.'
      else
        flash.now[:notice] = @revision.errors.full_messages.join('<br /')
      end
      redirect_to :back
    end
    
    # Delete an entity from all languages by marking it's status "deleted" to
    # true. Entities those have been deleted will be removed from the list.
    def delete
      @entity = GetText::Db::Entity.find(params[:id])
      
      if @entity.update_attribute( :deleted, true )
        flash[:notice] = 'Entity has been deleted.'
        redirect_to :action => 'list'
      else
        flash[:notice] = '[Error] Updating failed.'
        redirect_to :back
      end
    end
    
    def create_task
      entity = GetText::Db::Entity.find(params[:id])
      task = entity.tasks.build(params[:task])
      if task.save
        flash[:notice] = "Task \"#{task.name}\" created."
      else
        flash[:notice] = task.errors.full_messages.join("<br />")
        @task = task
      end
      
      redirect_to :back
    end
    
    def complete
      tasks = GetText::Task::Completion.update_all(
        "completed = true",
        ["language_id = ? AND task_id in (?)", @lang.id, params[:task_id]]
      )
      flash[:notice] = "#{tasks} task(s) has completed."
      redirect_to :back
    end
    
    # Publish current revision of all entities translation into website, by
    # calling rake task "gettext:publish" in background.
    # Note:
    # This task just build all files and it is still necessary to restart web
    # server manually.
    def publish
      (render && return) if request.get?
      
      if call_rake_task('gettext:publish')
        flash[:notice] = 'Completed. Restart web server to apply changes.'
      else
        flash[:notice] = '[Error] Publishing falied.'
      end
      redirect_to :action => 'index'
    end
    
  private
    
    def init
      @title = 'RED Translator'
      @lang = GetText::Db::Language.find_by_name(params[:lang]||"en_US")
    end
    
    # Call rake task in background.
    #   call_rake_task 'db:migrate', :RAILS_ENV => 'development', :VERSION => 10
    #   # => rake db:migrate RAILS_ENV=development VERSION=10
    def call_rake_task( task_name, options={} )
      command = [
        "rake #{task_name}",
        options.map { |k, v| [k.to_s.upcase, v.to_s].join('=') },
        ''
      ].join(' ')
      logger.info "Calling Rake Task >> #{command}"
      system(command)
    end
    
  end
end