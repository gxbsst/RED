class RegisterController < ApplicationController
  # layout "static_pages"

  def index
    if request.get?
      @warranty_registration = WarrantyRegistration.new(:country => "United States") # Set the default country to US.
    else
      @warranty_registration = WarrantyRegistration.new(params[:warranty_registration])
      if @warranty_registration.save
#   		flash[:notice]="Thank you for registering your RED Warranty"
#         redirect_to :action => 'success'
		render :template => 'register/success'
      else
        # flash[:notice] = params.to_yaml
        render :action => 'index'
      end
    end
  end
 
  	
def state_select
  render :partial => 'state_select', :locals => { :current_country => params[:country] }
end
def product_categories_select
    @select_name = params[:select_name]
    @selected = params[:selected]
    @product_categories = Tag.find(:all)[0..5]
    render :layout => false
end
#def product_select
#	if params[:product_categories_id]
# @product_categories_id=Array.new
#  @product_categories_id << params[:product_categories_id]
#  @products=Product.find_by_tags(@product_categories_id)
#  render :partial => 'product_select'
#  else
#  render :file => "#{RAILS_ROOT}/public/404.html"
#  end
#end

  # # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  # :redirect_to => { :action => :list }
  # 
  # def list
  #   @warranty_registration_pages, @warranty_registrations = paginate :warranty_registrations, :per_page => 10
  # end
  # 
  # def show
  #   @warranty_registration = WarrantyRegistration.find(params[:id])
  # end
  # 
  # def new
  #   @warranty_registration = WarrantyRegistration.new
  # end
  # 
  # def create
  #   @warranty_registration = WarrantyRegistration.new(params[:warranty_registration])
  #   if @warranty_registration.save
  #     flash[:notice] = 'WarrantyRegistration was successfully created.'
  #     redirect_to :action => 'index'
  #   else
  #     # flash[:notice] = params.to_yaml
  #     render :action => 'index'
  #   end
  # end
  # 
  # def edit
  #   @warranty_registration = WarrantyRegistration.find(params[:id])
  # end
  # 
  # def update
  #   @warranty_registration = WarrantyRegistration.find(params[:id])
  #   if @warranty_registration.update_attributes(params[:warranty_registration])
  #     flash[:notice] = 'WarrantyRegistration was successfully updated.'
  #     redirect_to :action => 'show', :id => @warranty_registration
  #   else
  #     render :action => 'edit'
  #   end
  # end
  # 
  # def destroy
  #   WarrantyRegistration.find(params[:id]).destroy
  #   redirect_to :action => 'list'
  # end
end
