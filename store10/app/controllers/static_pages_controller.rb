require 'hpricot'
require 'open-uri' 
#require 'net/http'
require 'rss'

class StaticPagesController < ApplicationController
  layout 'application'
  
  def index
    @page_title = 'RED / Index'
    
    #Analyzing RSS items from Word from Jim
    begin
      red_con = open("#{RAILS_ROOT}/tmp/recon.rss") {|f| f.read }
      #red_con = open('http://www.reduser.net/forum/external.php?type=RSS2&forumids=29').read
      @red_con = RSS::Parser.parse(red_con).items[0..10]
    rescue 
      @red_con = []
    end
    
    # Analyzing RSS items from reduser.net
    # TODO: The RSS source should be cached.
    begin
      #red_user_rss = open('http://www.reduser.net/forum/external.php?type=RSS2&forumids=1,2').read
      red_user_rss = open("#{RAILS_ROOT}/tmp/reduser.rss") {|f| f.read }
      @red_user_news = RSS::Parser.parse(red_user_rss).items[0..14]
    rescue
      @red_user_news = []
    end
    
    @downloads = DownloadCategory.find(:all, :include => :downloads,:order => DownloadCategory::VERSION_ORDER_CLAUSE).group_by { |download| download.code }
    
    @red_china = in_china?(detect_country)
  end
  
  def email_announcements
    # @page_title = _('PAGE_TITLE|EMAIL_ANNOUNCEMENTS')
    return unless request.post?
    
    @email_announcement = EmailAnnouncement.new(params[:email_announcement])
    if @email_announcement.save
      render :partial => 'email_announcement_success', :layout => true
    end
  end
  
  def gear_we_use
    # @page_title = _('PAGE_TITLE|GEAR_WE_USE')
  end
  
  def contact_us
    # @page_title = _('PAGE_TITLE|CONTACT_US')
  end
  
  def about_red
    # @page_title = _('PAGE_TITLE|ABOUT_RED')
  end
  
  def legal
    # @page_title = _('PAGE_TITLE|PRIVACY_POLICY')
  end
  
  def lenses
    # @page_title = _('PAGE_TITLE|LENSES')
  end
  
  def press
  end
  def shot_on_red
    # @page_title = _('PAGE_TITLE|SHOT_ON_RED')
  end
  def terms
    @agreement = Agreement.find(:first).latest_version
  end
  
  def printable_terms
    @agreement = Agreement.find_by_name( params[:id] )
    raise ActiveRecord::RecordNotFound.new if @agreement.blank?
    
    render :layout => false
  end
  
  def red_mythbusters
    # @page_title = " RED / RED Mythbusters"
  end
  
  def interviews
    # @page_title = " RED / Interviews"
  end

  def nikon_pads
    # @page_title = "RED / Nikon Pads"
  end

  def redtalks
    @page_title = "RED / REDTALKS"
  end
  
  def redcore
    @page_title = 'RED / RED Core'
  end
  
  private
  
  # Detect user's country and save into cookies.
  def detect_country
    return cookies[:country] unless cookies[:country].blank?
    
    location = Ip2address.find_location_by_ip(request.remote_ip)
    if location
      cookies[:country] = location.countrySHORT
      return location.countrySHORT
    end
  end
  
  def in_china?(short_country_name)
    return %w{CN TW HK MO}.include?(short_country_name)
  end
  
  # Cache all static pages in directory "public", except home page (with
  # dynamic contents - news rss, firmwares, etc)
  caches_page(*(self.action_methods - ['index']))
end
