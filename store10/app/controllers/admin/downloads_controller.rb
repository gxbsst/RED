class Admin::DownloadsController < Admin::BaseController
  include ActionView::Helpers::TextHelper
  
  def index
    @title = 'Downloads List'
    @downloads = DownloadCategory.find(:all, :order => 'position')
  end
  
  def new
    @title = "New Download"
    @download = DownloadCategory.new
  end
  
  def edit
    @download = DownloadCategory.find(params[:id])
    @title = "Download: #{@download.title}"
    render :action => "new"
  end
  
  def save
    if params[:id].blank?
      @title = "Create New Download"
      @download = DownloadCategory.new(params[:download])
      if @download.save
        redirect_to :action => "index"
      else
        render :action => "new"
      end
    else
      @title = "Edit Download"
      @download = DownloadCategory.find(params[:id])
      params[:download].delete("picture") if params[:download][:picture].size == 0
      if @download.update_attributes(params[:download])
        redirect_to :action => "index"
      else
        render :action => "new"
      end
    end
  end
  
  def destroy
    DownloadCategory.find(params[:id]).destroy
    redirect_to :action => "index"
  end

  def move
    download = DownloadCategory.find(params[:id])
    case params[:position]
    when 'highest' : download.move_to_top
    when 'higher'  : download.move_higher
    when 'lower'   : download.move_lower
    when 'lowest'  : download.move_to_bottom
    end if params[:position]
    redirect_to :action => 'index'
  end
  
  def new_version
    @title = "New Download Version"
    @download = DownloadCategory.find(params[:id])
    @version = Download.new
  end
  
  def edit_version
    @title = "Edit Download Version"
    @version = Download.find(params[:id])
    @download = @version.download_category
    render :action => "new_version"
  end
  
  def save_version
    @download = DownloadCategory.find(params[:download][:id])
    if params[:id].blank?
      @title = "Create New Download Version"
      @version = Download.new(params[:version])
      if @version.valid?
        @download.downloads << @version
        redirect_to :action => "edit", :id => @download
      else
        render :action => "new_version"
      end
    else
      @title = "Edit Download Version"
      @version = Download.find(params[:id])
      params[:version].delete("file") if params[:version][:file].size == 0
      if @version.update_attributes(params[:version])
        redirect_to :action => "edit", :id => @download
      else
        render :action => "new_version"
      end
    end
  end
  
  def download_file
    send_file File.join(Download::UPLOAD_PATH, params[:id])
  end
  
  def destroy_version
    Download.find(params[:id]).destroy
    redirect_to :action => "edit", :id => params[:download]
  end
  
  def preview
    case
    when !params[:download][:description].blank?
      render :text => textilize(params[:download][:description])
    when !params[:version][:release_note].blank?
      render :text => textilize(params[:version][:release_note])
    end
  end
  
end
