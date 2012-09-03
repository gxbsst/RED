# require 'ruby-debug'
class Admin::LogsController < Admin::BaseController
  
  def index
    @title = 'My Account Logs'
    if params[:list] == 'all'
      @search_result = MyAccountLog.find(:all, :order => 'created_at DESC' )
    else
      @search_result = MyAccountLog.find(:all,  :group => 'account_num', :limit => 30, :order => 'created_at DESC' )
    end
    # debugger
    @logs_pages = Paginator.new(self, @search_result.size, 30, params[:page])
    @sales_line_order_logs = @search_result[(@logs_pages.current.to_sql)[1], (@logs_pages.current.to_sql)[0]] 
    
  end
  
  def search
    # render :text => 'It just a test...'  
      # @account_num = 'CU 0100864'
      @title = "Search Results For '#{params[:term]}'"
      begin
      @search_result = search_items( params[:term] )
      @logs_pages = Paginator.new(self, @search_result.size, 30, params[:page])
      @sales_line_order_logs = @search_result[(@logs_pages.current.to_sql)[1], (@logs_pages.current.to_sql)[0]] 
    rescue
      flash[:notice] = 'No Found!'
      redirect_to :action => 'index'
    end
      # @sales_line_order_logs =  search( @account_num )
  end
  
  def record_detail
    log = MyAccountLog.find( params[:id] )
    @record =  log.record
    @sales_order_num = log.sales_order_num
    @account_num = log.account_num
    # debugger
    
    render :layout => false
  end
  
  def user_agent_detail
    @log  = MyAccountLog.find(params[:id])
    render :layout => false
    
  end
  
private
def search_items( term )
  # start_created_at = Time.now()
  # last_created_at  = start_created_at - default_days.days
  term =~ /^(CU|SO)[\s-]\d+/i
  # Judge the term is account num or sales order num

  unless $1.blank?
    # Search the logs with Account_num OR Sales_order_num
    if $1.upcase == 'CU' 
      @logs = MyAccountLog.find( :all, :conditions => ['account_num = ? ', term], :order => 'created_at DESC' )
    else
      $1.upcase == 'SO' 
      @logs = MyAccountLog.find( :all, :conditions => [' sales_order_num = ? ', term], :order => 'created_at DESC')
    end
  else
    # Search the logs with SN
    begin
      item        =  ERP::SerialNumber.find(:all, :conditions => ['serial_number  like ?  or serial like ?', ("%#{term}%"), ("%#{term}%")])
      account_num =  item.first.account_num
      @logs       =  MyAccountLog.find( :all, :conditions => ['account_num = ? ', account_num], :order => 'created_at DESC')
    rescue
      @logs = nil
    end
  end
  return @logs
end

end