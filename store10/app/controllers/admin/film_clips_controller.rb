module Admin
  class FilmClipsController < BaseController
    before_filter :set_page_title
    
    def index
      @film_clip_pages, @film_clips = paginate :film_clips,
        :per_page => 10, :order => 'id DESC'
    end
  
    def edit
      @film_clip = FilmClip.find(params[:id])
    end
    
    def update
      #Fixed deletes images with empty files for Firefox...
      params[:film_clip].delete(:thumbnail) if params[:film_clip][:thumbnail].size == 0
      
      @film_clip = FilmClip.find(params[:id])
      if @film_clip.update_attributes(params[:film_clip])
        flash[:notice] = 'Film clip updated.'
        redirect_to :action => 'edit', :id => @film_clip
      else
        flash.now[:notice] = @film_clip.errors.full_messages.join('<br />')
        render :action => 'edit'
      end
    end
    
    # Show a modal window to update the layout by listing in order.
    def order
      @title = 'Ordering Film Clips...'
      
      @film_clips = FilmClip.find(
        :all,
        :conditions => ['authorized = ? and sticked = ?', true, true],
        :order => 'position DESC',
        :limit => ::FilmClipsController::PAGE_SIZE
      )
      
      render :layout => 'modal'
    end
    
    def save_position
      size = params[:film_clips].size
      
      FilmClip.transaction do
        FilmClip.update_all('position = null', 'position IS NOT NULL')
        params[:film_clips].each_with_index do |id, index|
          FilmClip.update(id, :position => (size - index))
        end
      end
      
      redirect_to :back
    end
    
    def remove_from_top
      @film_clip = FilmClip.find(params[:id])
      @film_clip.sticked = false
      @removed = @film_clip.save
    end
    
    def authorize
      @film_clip = FilmClip.find(params[:id])
      @film_clip.authorized = true
      if @film_clip.save
        flash[:notice] = 'Film clip authorized.'
      else
        flash[:notice] = 'Operation failed'
      end
      
      redirect_to :back
    end
    
    def destroy
      @film_clip = FilmClip.find(params[:id])
      @film.destory
      redirect_to :back
    end
    
  private
    def set_page_title
      @title = 'Film Clips'
    end
  end
end
