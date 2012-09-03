class Admin::AccountsController < Admin::BaseController
  def index
    @title = 'Store User List'
    @user_pages, @users = paginate :store_user, :per_page => 30, :order => "id DESC"
  end

  def new
    @title = "Add New Account"
    @store_user = StoreUser.new
  end

  def create
    @store_user = StoreUser.new(params[:store_user])
    if @store_user.valid? && @store_user.save
      # send password mail
      if params[:generate_password_mail] == '1'
        @store_user.update_security_token
        StoreUserNotify.deliver_auto_generated(@store_user, url_for(:controller => '/account', :action => 'reset_password', :token => @store_user.security_token, :host => request.host_with_port))
      end
      flash[:notice] = 'Account was successfully created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @title = "Editing Account"
    @store_user = StoreUser.find(params[:id])
  end

  def update
    @store_user = StoreUser.find(params[:id])
    store_user = @store_user.update_attributes(params[:store_user])
    if store_user
      flash.now[:notice] = 'Account was successfully updated.'
      render :action => 'edit'
    else
      flash.now[:notice] = 'There were problems edit the account.'
      render :action => 'edit'
    end
  end

  def destroy
    StoreUser.find(params[:id]).destroy
    redirect_to :action => 'index'
  end

  def search
    if params[:term].blank?
      redirect_to :action => 'index'
      return
    end
    @title = "Search Results For '#{params[:term]}'"
    @term = params[:term]
    @search_result = StoreUser.find(:all, :conditions => ['name LIKE ? OR email_address LIKE ? OR company LIKE ? OR erp_account_number LIKE ?', "%#{@term}%", "%#{@term}%", "%#{@term}%", "%#{@term}%"])
    @user_pages = Paginator.new(self, @search_result.size, 30, params[:page])
    @users = @search_result[(@user_pages.current.to_sql)[1], (@user_pages.current.to_sql)[0]] 
  end

  def reset_password
    @store_user = StoreUser.find(params[:id])
    @store_user.update_security_token
    StoreUserNotify.deliver_reset_password(@store_user, url_for(:controller => '/account', :action => 'reset_password', :token => @store_user.security_token, :host => request.host_with_port))
    render :text => '<h2 style="color: #FF0000;">Send password mail successfull</h2>'
  end
  
  # Undo all changes done in "My Account" by re-synchronizing data
  # Find customer via giben customer account number
  def undo_changes
    customer = ERP::Customer.find_by_account_num( params[:id] )
    if customer.undo_changes
      flash[:notice] = "Changes of customer(#{params[:id]}) have been rolled back."
    else
      flash[:notice] = "Faied to roll back changes of customer."
    end
    
    redirect_to :back
  end
end
