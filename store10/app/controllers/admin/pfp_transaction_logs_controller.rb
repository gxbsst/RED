class Admin::PfpTransactionLogsController < Admin::BaseController
  def index
    @title = 'PFP Transaction Logs'
    @pfp_log_pages, @pfp_logs = paginate :'PfpTransactionLog', :per_page => 30, :order => "id DESC"
  end
  
  def search
    if params[:term].blank?
      redirect_to :action => 'index'
      return
    end
    @title = "Search Results For '#{params[:term]}'"
    @term = params[:term]
    # TODO:
    # How direct to know a string can or can't convert to a date object?
    begin
      date = @term.to_date.to_s(:db)
      # TODO:
      # How dynamic find been convert to sql include 'distinct'?
      @search_result = PfpTransactionLog.find(:all, :conditions => ['card_name LIKE ? OR email_address LIKE ? OR order_number LIKE ? OR req_xml LIKE ? or created_on LIKE ?', "%#{@term}%", "%#{@term}%", "%#{@term}%", "%#{@term}%", "%#{date}%"])
      @pfp_log_pages = Paginator.new(self, @search_result.size, 30, params[:page])
      @pfp_logs = @search_result[(@pfp_log_pages.current.to_sql)[1], (@pfp_log_pages.current.to_sql)[0]] 
    rescue
      @search_result = PfpTransactionLog.find(:all, :conditions => ['card_name LIKE ? OR email_address LIKE ? OR order_number LIKE ? OR req_xml LIKE ?', "%#{@term}%", "%#{@term}%", "%#{@term}%", "%#{@term}%"])
      @pfp_log_pages = Paginator.new(self, @search_result.size, 30, params[:page])
      @pfp_logs = @search_result[(@pfp_log_pages.current.to_sql)[1], (@pfp_log_pages.current.to_sql)[0]] 
    end
  end
  
  def show
    @pfp_log  = PfpTransactionLog.find(params[:id])
    @title = "FPF Transaction Log Detail - #{@pfp_log.created_at.to_s(:db)}"
  end
  
  def download_pfp_cc_res_pdf
    send_file "#{RAILS_ROOT}/public/files/PayFlowCreditCardResponses.pdf"
  end
end
