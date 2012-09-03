class IndieController < ApplicationController
  # layout 'static_pages'
  def thenothingmen
    @page_title = " RED / The Nothing Men"
  end
  def achchamundu
    @page_title = " RED / Achchamundu "
    render :layout => false
  end
  
end
