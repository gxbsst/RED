class Admin::EventsController < Admin::BaseController
  layout 'admin'
  helper :sort
  include SortHelper
  
  def index
    sort_init 'id'
    sort_update
    
    @title = "List all people"
    @participanters = Participant.find( :all, :order => sort_clause )
  end    
  
  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = 'China Event was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'index'
    end
  end
  
  def new
    @title = "Create a new event"
    @event = Event.new
  end
  
  def edit
    @title = "Edit A Participanter"
    @participant = Participant.find(params[:id])
  end
  
  def update
    @participant = Participant.find(params[:id])
    if @participant.update_attributes(params[:participant])
      flash[:notice] = "'#{@participant.name}' was successfully updated."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def search
    sort_init 'id'
    sort_update

    @search_term = params[:term]
    if !@search_term then
      @search_term = session[:last_search_term]
    end
    # Save this for after editing
    session[:last_search_term] = @search_term
    # Need this so that links show up
    @title = "Search Results For '#{@search_term}'"
    @participanters = Participant.search(@search_term)
    render :action => 'index'
  end
  
  
  def show_available_people
    sort_init 'id'
    sort_update
    
    @title = 'Show available people'
    @participanters = Participant.find(:all, :conditions => ["deleted = ?", 1], :order => sort_clause)
  end
  
  def show_unavailable_people
    sort_init 'id'
    sort_update
    
    @title = 'Show available people'
    @participanters = Participant.find(:all, :conditions => ["deleted = ?", 0], :order => sort_clause)
  end
  
  def count_people
    @title = "Conunt Participanter"
    @participanters = Participant.find :all
    @cities = @participanters.map(&:city)
    @provinces = @participanters.map(&:province).uniq
    
    @group_by_province = @provinces.inject([]) do |arr,prov|
      arr << @participanters.select{|p| p.province == prov }
    end
    
    @group_by_city = @cities.inject([]) do |arr,c|
      arr << @participanters.select{|p| p.city == c }
    end
  end
  
  def show_all_events
    sort_init 'id'
    sort_update
    
    @title = 'Show all events'
    @events = Event.find(:all, :order => sort_clause)
  end
  
  def edit_event
    @title = "Edit A Event"
    @event = Event.find(params[:id])
  end
  
  def update_event
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "'#{@event.name}' was successfully updated."
      redirect_to :action => 'index'
    else
      render :action => 'edit_event'
    end
  end
  
  def destroy
    Participant.find(params[:id]).destroy
    redirect_to :action => 'index'
  end
end