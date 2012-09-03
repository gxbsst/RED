class Admin::NewsController < ApplicationController
  layout 'news_admin'
   helper :news_post_timestamp
  #layout 'main',:only => [:list,:index,:show,:permalink]
  before_filter :authorize ,:only =>[:add_news,:index,:delete,:edit,:create,:update,:show]
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
  :redirect_to => { :action => :list }
  #for news admin authentication

  def index
    redirect_to :controller =>'/news', :action => 'list' if session[:user_id]
  end

  def add_news
    if request.get?
      @news = News.new
      begin
        #create folder in images,please set the folder can be writen
        FileUtils.mkdir_p "#{RAILS_ROOT}/public/images/news/#{@news.random_id}"
        FileUtils.chmod(0777, "#{RAILS_ROOT}/public/images/news/#{@news.random_id}")
      rescue Exception => create_folder
        flash[:notice] = "#{create_folder}"
      end
      render
      return
    end
    if params[:commit] == "Create"
      begin
        @news = News.new(params[:news])

        # FileUtils.mkdir_p "#{RAILS_ROOT}/public/images/news/#{@news.random_id}"
        #filename=params['description_img'].original_filename
        #upload descriotn images
        unless params[:description_img].blank?
          File.open("#{RAILS_ROOT}/public/images/news/#{params[:news][:random_id]}/description.jpg","wb") do |f|
            f.write( params[:description_img].read)
          end
        end

        if @news.save
          flash[:notice] = 'News was successfully created.'
          redirect_to :controller =>'/news', :action => 'list'
        else
          render :controller => "/news", :action => "list"
        end

      rescue Exception => dir_error
        flash[:notice] = "#{dir_error}"
        render :action => 'add_news'
      end

    else
      @news = News.new(params[:news])
      render :action => "preview", :layout => 'static_pages'
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    if params[:commit] =="edit"
      #unless  params[:description_img].kind_of? StringIO
      unless  params[:description_img].size == 0
       begin File.open("#{RAILS_ROOT}/public/images/news/#{@news.random_id}/description.jpg","wb") do |f| 
          f.write(params[:description_img].read)
        end
      rescue Ecexption => img_err
        flash[:notice] = "#{img_err}"
      end
      end
      if @news.update_attributes(params[:news])
        flash[:notice] = 'News was successfully updated.'
        redirect_to :controller =>'/news',:action => 'show', :id => @news
      else
        render :action => 'edit'
      end
    else
      render :action =>'preview',:layout => 'static_pages'
    end
  end

  def delete 
    News.find(params[:id]).destroy
    redirect_to :controller => '/news',:action => 'list'
    #render :layout => false
  end

  def preview
    @news =News.new(params[:news]) 
    render :action => 'show', :layout =>"static_pages" 
  end
private
  def authorize
     unless session[:user_id]
       flash[:notice]= "Please Login"
       redirect_to(:controller => "/admin/news_admin_users", :action => "login")
     end
   end



end

