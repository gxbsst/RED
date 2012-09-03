# Recognize routings for cameras products (RED ONE, Epic, Scarlet) by handling
# current URL as template file.
# 
# Example:
#   [GET] /cameras                      # => render 'cameras/index'
#   [GET] /cameras/red_one              # => render 'cameras/red_one/overview'
#                                            as default for each product
#   [GET] /cameras/red_one/tech_specs   # => render 'cameras/red_one/tech_specs'
class CamerasController < ApplicationController
  require 'hpricot'
  
  after_filter :append_sub_navigator, :only => [:epic, :red_one, :scarlet]
  caches_page :red_one, :epic, :scarlet, :quotes
  
  def index
    redirect_to :action =>'red_one', :id => 'overview'
  end
  
  def red_one
    recognize_path
  end
  
  def epic
    recognize_path
  end
  
  def scarlet
    recognize_path
  end
    
  def example_configurations
    @example_configurations = ExampleConfiguration.find :all, :limit => 3
  end
  
  private
    def recognize_path
      # 'overview' as default for each product
      render :template => File.join(params[:controller], params[:action], params[:id] || 'overview')
    end
    
    def append_sub_navigator
      doc = Hpricot(response.body)
      if (heading = doc/'div.heading')
        erase_results if performed?
        heading.inner_html = render_to_string(:partial => 'sub_navigator')
        response.body = doc.to_html
      end
    end
end
