class NabController < ApplicationController
  # layout 'static_pages'

  def index
    render 'nab/redray'
    @page_title = "RED / RED RAY"
    
  end

  def redray
    @page_title = "RED / RED RAY"
  end

  def lenses
    @page_title = "RED / LENSES"
  end
end
