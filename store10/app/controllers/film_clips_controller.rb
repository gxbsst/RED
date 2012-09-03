class FilmClipsController < ApplicationController
  before_filter :login_required, :only => [:new, :create]
  
  PAGE_SIZE = 20
  
  # Show the first screen of authorized film clipe marked as "sticked".
  # 
  # TODO:
  # Remove the original "shot_on_red" page and replace using this. Maybe the
  # routes configuration need to be modified.s
  def index
    redirect_to :controller => 'static_pages', :action => 'shot_on_red'
  end
  
  # Show all authorized film clips paginated. Notice those clips marked as
  # "sticked" will be on the top page of all and be listed in order specified.
  def more
    if params[:page] =~ /^\d+$/ && params[:page].to_i > 0
      @page = params[:page].to_i
    else
      @page = 1
    end
    
    @film_clips = FilmClip.find(
      :all,
      :conditions => ['authorized = ?', true],
      :order => 'sticked, position DESC, id DESC',
      :offset => (@page - 1) * PAGE_SIZE,
      :limit => PAGE_SIZE
    )
    @counts = FilmClip.count(:conditions => ['authorized = ?', true])
    
    @film_pages, @films = paginate :film_clips, :per_page => PAGE_SIZE, :order => "id DESC"
    
    render :action => 'index'
  end
  
  def show
    @film_clip = FilmClip.find_by_authorized_and_id(true, params[:id])
    raise ActiveRecord::RecordNotFound unless @film_clip
  end
  
  # Show a page to user to upload their film made by RED cameras.
  def new
    @film_clip = FilmClip.new
  end
  
  # Create film clip record and save their clip.
  def create
    @film_clip = FilmClip.new(params[:film_clip])
    @film_clip.account_num = session[:web_user].erp_account_number
    @film_clip.email = session[:web_user].email
    @film_clip.name = session[:web_user].name
    
    if @film_clip.save
      flash[:notice] = 'Upload successfully.'
      redirect_to :action => 'index'
    else
      flash.now[:notice] = @film_clip.errors.full_messages.join('<br />')
      render :action => 'new'
    end
  end
  
  private
    # All users (including those do not have a camera yet) can upload their
    # film clips.
    def login_required
      flash[:login_mode] = 'all'
      return user_authentication
    end
end
