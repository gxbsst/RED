class RssController < ApplicationController
  
  before_filter :set_content_type, :only => ['reduser', 'recon']
  
  layout nil
  
  def reduser
    render :file => File.join(RAILS_ROOT, 'tmp', 'reduser.rss')
  end
  
  def recon
    render :file => File.join(RAILS_ROOT, 'tmp', 'recon.rss')
  end
  
  private
  def set_content_type
    headers["Content-Type"] = "text/xml; charset=utf-8"
  end
end
