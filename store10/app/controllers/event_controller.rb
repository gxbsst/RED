class EventController < ApplicationController
  layout 'static_pages'
  TRANSLATION = YAML.load_file("config/configurations/red_china/translation.yml")
  PREFERED_LANGUAGE = {
    "CN" => "simplified",
    "TW" => "traditional",
    "HK" => "traditional",
    "MO" => "simplified"
  }.freeze
  
  def red_china
    return unless detect_prefered_language
    
    @page_title = 'RED / China Events'
    @event = Event.find(:first)
    @participant = @event.participants.build
  end
  
  def create
    # GET request to this action should be redirected back.
    unless request.post?
      redirect_to :action => "red_china", :id => params[:id]
      return false
    end
    
    params[:participant][:scope_of_business] =  params[:participant][:scope_of_business].join(",")
    @participant = Participant.new(params[:participant])
    if @participant.save
      flash[:notice] = g_("NOTICE_SUCCESS")
      redirect_to :back
    else
      flash.now[:notice] = g_("NOTICE_FAILED")
      render :action => "red_china"
    end
  end
  
  
  private
  
  # I18n support methods for RED China event.
  helper_method :g_
  def g_(string, textile = false)
    lang = params[:id] || "english"
    text = TRANSLATION[lang][string] || "&raquo;#{string.upcase}&laquo;"
    if textile
      return RedCloth.new(text, [:no_span_caps, :hard_breaks]).to_html
    else
      return text
    end
  end
  
  # If no language specified in url (as id), detect and redirect to the most
  # suitable language accourding user's country (saved in cookies in homepage).
  # Otherwise, return English as default setting for unknown ip.
  def detect_prefered_language
    unless TRANSLATION.keys.include?(params[:id])
      redirect_to :id => PREFERED_LANGUAGE[cookies[:country]] || "english"
    end
    return true
  end
end
