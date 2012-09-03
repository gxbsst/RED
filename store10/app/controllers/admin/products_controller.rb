class Admin::ProductsController < Admin::BaseController
  helper :sort
  include SortHelper
  
  def index
    list
    render :action => 'list'
  end

  # Lists all products
  def list
    sort_init 'name'
    sort_update
    
    @title = "All Product List"
    @tags = Tag.find_alpha
    @product_pages,	@products = paginate :product, :per_page => 30, :order_by => sort_clause
  end

  def control_store_index
    sort_init 'sequence'
    sort_update
    
    @title = "Edit STORE Page"
    @tags = Tag.find_alpha
    @products = Product.find(:all, :conditions => ["is_featured = ?",1] , :order => sort_clause)
  end

  # Lists products by tag
  def list_by_tags
    sort_init 'product_sort_id'
    sort_update 
    
    @tags = Tag.find_alpha

    @list_options = Tag.find_alpha

    if params[:key] then
      @viewing_by = params[:key]
    elsif session[:last_product_list_view] then
      @viewing_by = session[:last_product_list_view]
    else
      @viewing_by = @list_options[0].id
    end

    @tag = Tag.find(:first, :conditions => ["id=?", @viewing_by])
    if @tag == nil then
      redirect_to :action => 'list'
      return
    end

    @title = "Product List For Tag - '#{@tag.name}'"
    session[:last_product_list_view] = @viewing_by
    tag_product_ids = @tag.products.map{|product| product.id}
    begin
     if sort_clause.match(/product_sort_id/)
       products = ActiveRecord::Base.connection.select_all("select product_id from products_tags where tag_id = #{@tag.id } order by #{sort_clause} ;")
       @products =  products.inject([]) do |products_all,product|
         products_all << Product.find_by_id(product["product_id"])
       end
     else
     @products = Product.find(:all, :conditions => ["id IN (?)",tag_product_ids], :order => sort_clause)
     end
    rescue
     @products = @tag.products
    end
    render :action => 'list'
  end


  def show
    @product = Product.find(params[:id])
  end

  def new
    @title = "New Product"
    @image = Image.new
    @product = Product.new
    @tags = Tag.find_alpha
  end

  def create
    @title = "New Product"
    @product = Product.new(params[:product])
    if @product.save
      # Save product tags
      # Our method doesn't save tags properly if the product doesn't already exist.
      # Make sure it gets called after the product has an ID
      @product.tags = params[:product][:tags] if params[:product][:tags]
      # Save product images
      if (!params[:image][:path].blank?) then
        @product.images.build(params[:image])
      end
      # Save again to keep our changes
      @product.save!
      flash[:notice] = "Product '#{@product.name}' was successfully created."
      redirect_to :action => 'list'
    else
      @image = Image.new
      render :action => 'new'
    end
  end

  def edit
    @title = "Editing A Product"
    @product = Product.find(params[:id])
    @image = Image.new
    @tags = Tag.find_alpha
  end

  def update
    @product = Product.find(params[:id])
    @tags = Tag.find_alpha
    @product_display_orders = @product.tags.inject([]) do |product_sort_ids,tag|
      sort_id = @product.read_display_order(@product.id,tag.id)
      product_sort_ids << {:product_id => @product.id,:tag_id => tag.id, :sort_id => sort_id["product_sort_id"]}
    end
    
    if @product.update_attributes(params[:product])
      image_path = params[:image][:path]
      logger.info("\n\n[info] IMAGE PATH LENGTH: #{image_path.length}")
      logger.info("\n[info] IMAGE PATH: #{image_path}")
      logger.info("\n[info] IMAGE BLANK?: #{image_path.blank?}\n\n")
      if (!image_path.blank? && image_path.length > 0) then
        for image in @product.images
          image.destroy
        end
        @product.images.build(params[:image])
        @product.save!
      end
      @product_display_orders.each do |order_id|
        ActiveRecord::Base.connection.execute("UPDATE products_tags
                                               SET product_sort_id = #{order_id[:sort_id]} 
                                               WHERE product_id = #{order_id[:product_id]} 
                                               AND tag_id = #{order_id[:tag_id]}"
                                              ) unless order_id[:sort_id].blank?
      end
      
      flash[:notice] = "Product '#{@product.name}' was successfully updated."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  # Search uses the list view as well.
  # We create a custom paginator to show search results since there might be a ton
  def search
    sort_init 'name'
    sort_update
    
    @search_term = params[:term]

    if !@search_term then
      @search_term = session[:last_search_term]
    end
    # Save this for after editing
    session[:last_search_term] = @search_term

    # Need this so that links show up
    @title = "Search Results For '#{@search_term}'"
    @tags = Tag.find_alpha
    @search_count = Product.search(@search_term, true, nil)
    @product_pages = Paginator.new(self, @search_count, 30, params[:page])
    # to_sql is an array
    # it seems to return the limits in reverse order for mysql's liking
    the_sql = @product_pages.current.to_sql.reverse.join(',')
    products = Product.search(@search_term, false, the_sql)
    product_ids = products.map(&:id)
    begin
    @product_pages, @products = paginate :product, :conditions => ["id IN (?)",product_ids], :order_by => sort_clause, :per_page => 10
    rescue
      @products = []
    end
    render :action => 'list'
  end

  def sync_products_data_report
    @new_items     = SyncAxProduct.find(:all,:conditions => ["status = ?","new_items"])
    @removed_items = SyncAxProduct.find(:all,:conditions => ["status = ?","removed_items"])
    
    @changed_items = SyncAxProduct.find(:all,:conditions => ["status = ?","changed_items"])
    @changed_items_for_code_equal_to_0_1 = SyncAxProduct.get_delivery_code_equal_to_0_1( @changed_items )
    @changed_items_for_code_equal_to_others = SyncAxProduct.get_delivery_code_equal_to_others( @changed_items )
  end

  def ignore_display_in_sync_report
    unless params[:item].blank?
      params[:item]['is_ignore'].each do |id|
        ActiveRecord::Base.connection.execute("UPDATE sync_ax_products set is_ignore = '1' where product_id = #{id} ")
      end
      flash[:notice] = "updated successfully."
    else
      flash[:notice] = "updated nothing."
    end
    redirect_to :action => 'sync_products_data_report'
  end
  
  def unignore_display_in_sync_report
    unless params[:item].blank?
      params[:item]['is_ignore'].each do |id|
        ActiveRecord::Base.connection.execute("UPDATE sync_ax_products set is_ignore = '0' where product_id = #{id} ")
      end
      flash[:notice] = "updated successfully."
    else
      flash[:notice] = "updated nothing."
    end
    redirect_to :action => 'sync_products_data_report'
  end
  # #list products accord with delivery_message and delivery_code
  # def search_by_delivery_code
  #   sort_init 'name'
  #   sort_update
  #   
  #   
  #   @code = (params[:product].blank?) ? nil :( params[:product][:delivery_code].to_i)
  #   unless @code
  #     @code = session[:last_search_code]
  #   end
  #   
  #   session[:last_search_code] = @code
  #   # Need this so that links show up
  #   @title = "Search Results For '#{@code}'"
  #   @tags = Tag.find_alpha
  #   @search_count = Product.search_by_delivery_code(@code)
  #   @product_pages = Paginator.new(self, @code, 30, params[:page])
  #   # to_sql is an array
  #   # it seems to return the limits in reverse order for mysql's liking
  # 
  #   products = Product.search_by_delivery_code(@code)
  # 
  #   product_ids = products.map(&:id)
  #   begin
  #   @product_pages, @products = paginate :product, :conditions => ["id IN (?)",product_ids], :order_by => sort_clause, :per_page => 10
  #   rescue
  #     @products = []
  #   end
  #   render :action => 'list'
  #   
  # end


  # Called when updating Tags from the product edit page
  # Returns the rendered partial for our Tag list
  def get_tags
    @tags = Tag.find_alpha
    if !params[:id].blank? then
      @product = Product.find(params[:id])
    else
      @product = Product.new
    end
    @partial_name = params[:partial_name]
    render(:partial => @partial_name,
    :collection => @tags,
    :locals => {:product => @product})
  end
  
  def update_products_order
    product_ids = params[:list]
    tag_key = params[:key]
    product_ids.each_with_index do |value, index|
      ActiveRecord::Base.connection.execute("UPDATE products_tags set product_sort_id = #{index + 1} where product_id = #{value} AND tag_id = #{tag_key}")
      # ProductsTag.find(:first, :conditions => ['product_id = ? AND tag_id = ?', value, tag_key]).update_attribute(:order, index.to_i)
    end
    render :nothing => true
  end

  # def update_store_index_products
  #   product_ids = params[:product]
  #  
  #   product_ids.each do |v|
  #     ActiveRecord::Base.connection.execute("UPDATE products set store_index_line = #{v[1]["store_index_line"]} where id = #{v[0]} ")
  #   end
  #   flash[:notice] = "Product order was successfully fixed in store index."
  #   redirect_to :action => "control_store_index"
  # end
  
  def update_sequence
    product_ids = params[:list]

    arr_change(product_ids).each do |arr|
      arr.each do |product_id|
        ActiveRecord::Base.connection.execute("UPDATE products set end_of_line = 0 where id = #{product_id} ") 
        if product_id == arr.last
          ActiveRecord::Base.connection.execute("UPDATE products set end_of_line = 1 where id = #{product_id} ") 
        end
      end
    end
    
    product_ids.delete_if{|i| i == 'line'}.each_with_index do |value, index|
      ActiveRecord::Base.connection.execute("UPDATE products set sequence = #{index + 1} where id = #{value} ")
    end
    
    render :nothing => true
  end
  
  def arr_change(arr)
    result = []
    temp_arr=[]
    arr.each do |elem|
      if elem != 'line'
        temp_arr<<elem
      end
      if elem == 'line'
        result<<temp_arr
        temp_arr=[]
        next
      end

      if elem==arr[-1]
        result << temp_arr
        temp_arr=[]
        break
      end
    end    
    return result 
  end

  
end
