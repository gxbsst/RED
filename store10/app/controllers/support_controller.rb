require 'digest'

class SupportController < ApplicationController
  layout 'application'
  
  def index
    # Select all categories from database.
    download_categories = DownloadCategory.find(
      :all,
      :conditions => ['disable != ?', true],
      :include => 'downloads',
      :order => 'download_categories.position, ' << DownloadCategory::VERSION_ORDER_CLAUSE
    )
    
    # Select the best version on user's platform.
    # If no record is matched, return the latest version in ALL platforms.
    os = detect_os
    
    @categories = download_categories.collect do |category|
      download = category.downloads.select{|download| download.attributes[os.downcase] || download.all_platform_available? }.first
      [category, download]
    end
    #@categories = @categories.group_by { |category| category.first.code }
    
    # headers['Content-Type'] = 'text/plain'
    # render :text => @categories.to_yaml
  end
  
  def release_history
    # Redirect to support homepage if no category_id has been provided.
    redirect_to(:action => 'index') && return if params[:id].blank?
    
    # Select all categories from database, using as sidebar links.
    @download_categories = DownloadCategory.find(
      :all,
      :conditions => ["disable <> ?", true],
      :order => 'title'
    )
    
    @category = DownloadCategory.find params[:id]
  end
  
  # Download specified software.
  # Original file IS NOT accessible, a symble link will be created before sending date to client.
  def download
    download = Download.find params[:id]
    
    # If this download is available only after login, execute an authentication process.
    return if download.restrict && !user_authentication
    
    # Download contains an agreement
    if download.agreement
      # Redirect to the agreement page if it is a GET request.
      unless request.post?
        render :partial => 'agreement', :object => download.agreement, :layout => true
        return false
      end
      
      if params[:commit] == 'Accept'
        # User accept this agreement, log this event and then continue.
        agreement_log = AgreementLog.create(
          :agreement => download.agreement,
          :download => download,
          :remote_ip => request.remote_ip,
          :store_user => (session[:web_user].nil? ? nil : session[:web_user]),
          :http_header => request.env.to_yaml
        )
      else
        # User does not accept this agreement, redirect to support page.
        redirect_to :action => 'index'
        return false
      end
    end
    
    # Generate a symbolic link for this file to download.
    # After deploied on server, a CRON job will clean up these links every 30 minutes.
    path = Digest::SHA1.hexdigest("#{session.session_id} @ #{Time.now.to_f}")
    path << ".u_#{session[:web_user].id}" if download.restrict
    path << ".a_#{agreement_log.id}" if download.agreement
    filename = download.filename
    
    FileUtils.mkdir "./public/downloads/#{path}" unless File.directory? "./public/downloads/#{path}"
    target_file = "./public/downloads/#{path}/#{filename}"
    
    # Codes for test only. Delete 2 lines below.
    # render :text => "Redirect to /downloads/#{path}/#{filename}"
    # return false
    
    unless File.symlink("#{RAILS_ROOT}/downloads/#{download.filename}", target_file) == 0
      render :text => "Sorry, system is busy now. Please try again several seconds later."
      return false
    end
    
    # Log this file name in database.
    File.open('log/download.log', 'a') { |file| file.puts "downloads/#{path}/#{filename}" }

    redirect_to "/downloads/#{path}/#{filename}"
  end
  
  # Special download page for Final Cut Studio Plugin
  def apple
    @category = DownloadCategory.find :first, :conditions => ['code = ?', 'quicktime_plugin']
    @page_title = 'RED.com / ' + @category.title
    render :layout => 'static_pages'
  end
  
  private
  
  # Detect the Operation System of client via HTTP_USER_AGENT
  def detect_os
    user_agent = request.env['HTTP_USER_AGENT']
    if user_agent =~ /(Windows|Mac)/
      return $1
    end
    return 'Unknow OS'
  end
  
end
