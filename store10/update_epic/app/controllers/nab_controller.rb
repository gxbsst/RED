class NabController < ApplicationController
  layout 'static_pages'

  def index
    epic
    render 'nab/red_ray'
    @page_title = "RED / EPIC"
    
  end
  def red_ray
    @page_title = "RED / RED RAY"
  end

  def lenses
    @page_title = "RED / LENSES"
  end
end
