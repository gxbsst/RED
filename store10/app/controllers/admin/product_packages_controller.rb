# Product Package Editor
# Each package or product item works as a node of entire tree.
class Admin::ProductPackagesController < Admin::BaseController
  
  # List top packages.
  def index
    @child_nodes = ProductPackage.find :all, :conditions => "parent_id IS NULL", :order => "position"
    
    @configurations = ExampleConfiguration.find :all
  end
  
  # Re-order items in specified sequence.
  # Accessible only for Ajax request.
  def change_order
    ids = params[:child_nodes]
    
    # Update
    ProductPackageNode.transaction do
      ids.each_index do |index|
        ProductPackageNode.update ids[index], :position => index + 1
      end
    end
    
    render :nothing => true
  end
  
  # Edit a product package, also return a list of all sub-items.
  def edit
    # GET request, return the editor page.
    @package = ProductPackage.find params[:id]
    @child_nodes = @package.product_package_nodes
    render && return unless request.post?
    
    # Update node attributes
    @package.update_attributes params[:package]
    flash[:notice] = "Package \"#{@package.name}\" was successfully saved!"
    
    # Redirect back
    redirect_to @package.parent_id.nil? ? { :action => "index" } : { :action => "edit", :id => @package.parent_id }
  end
  
  # Edit a product node under a package.
  def edit_package_product
    @node = ProductPackageProduct.find params[:id]
    
    # Update for POST request
    if request.post?
      @node.update_attributes params[:node].merge :description => params[:node][:description] || @node.product.description
      flash[:notice] = "Package Product \"#{@node.product.name}\" was updated!"
      redirect_to :action => "edit", :id => @node.parent_id
      return
    end
  end
  
  # Append an node to parent package.
  def append_node
    # Load parent package.
    parent_package = ProductPackage.find params[:id], :include => "product_package_nodes"
    # position = parent_package.product_package_nodes.collect{|node| node.position}.sort.last.nexts
    
    # Build a child node.
    case params[:node_type]
    when "package"
      parent_package.product_package_nodes << ProductPackage.new(:name => params[:new_package_name])
    when "product"
      parent_package.product_package_nodes << ProductPackageProduct.new(:product_id => params[:product_id], :display_style => "checkbox")
    end
    
    # Save node and redirect back.
    redirect_to :back
  end
  
  # Create a new package under the ROOT
  # Note:
  # Using this method only for create an root package. If you want to create a package
  #   under another (as a sub-package), using "append_node" via ajax request. Get more
  #   codes in "edit.rhtml"
  def create
    @package = ProductPackage.new
    render && return unless request.post?
    
    # POST method
    # Create a new package and then redirect to the list.
    @package = ProductPackage.create params[:package]
    flash[:notice] = "Package \"#{@package.name}\" was successfully created!"
    redirect_to :action => "edit", :id => @package.id
  end
  
  # Delete nodes with given id
  def delete
  	ProductPackageNode.delete params[:node_ids]
    render :nothing => true
  end
  
  # Example Configuration
  def edit_configuration
    @configuration = ExampleConfiguration.find_by_id(params[:id]) || ExampleConfiguration.new
    
    # Create or update for POST request
    if request.post?
      @configuration.update_attributes(params[:configuration])
      redirect_to :action => "index"
    end
  end
  
  # Products list in example configuration.
  # Note:
  #   Response an simple list (display in right side) for Ajax request.
  def configuration_products
    @configuration = ExampleConfiguration.find params[:id], :include => :example_configuration_products
    
    # Simple list for Ajax request
    if request.xhr?
      render :partial => "configuration_products"
      return false
    end
    
    @title = "Manage products for current configuration"
    
    # Post request for append new item
    if request.post?
      @configuration.example_configuration_products.create :product_id => params[:product_id], :quantity => params[:product_quantity]
    end
    
    render :partial => "edit_configuration_products", :layout => "modal"
  end
  
  # Remove product from an configuration
  def remove_configuration_product
    # node = ProductPackageProduct.find(params[:id].to_i).destroy
    # redirect_to :action => "configuration_products", :id => node.parent_id
    ExampleConfigurationProduct.delete params[:id]
    redirect_to :action => "configuration_products", :id => params[:id]
  end
end