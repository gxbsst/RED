namespace :report do
  desc "Website and AX/ERP variance report."
  task :website_ax_variance => :environment do
    begin
      require 'erp_log/ax_store_user_log'
      weekly,orders,ax_logs,pfp_logs,erp_logs, my_account_logs = (1..7).map{|i| Date.today - 8 + i},[],[],[],[],[]

      weekly.each do |date|
        orders   << ErpOrder.find(:all, :conditions => ['created_on >= ? and created_on < ?', date.to_s(:db), (date+1).to_s(:db)])
        ax_logs  << ErpLog::AxStoreUserLog.find(:all, :conditions => ['created_on >= ? and created_on < ?', date.to_s(:db), (date+1).to_s(:db)])
        pfp_logs << PfpTransactionLog.find(:all, :conditions => ['created_at >= ? and created_at < ?', date.to_s(:db), (date+1).to_s(:db)])
        
        #For sales order commite and customer commite...
        erp_logs << ERP::ERPLog.find_by_sql(["SELECT code, service_url from erp_logs WHERE  created_at >= ? AND created_at < ?",  date.to_s(:db), (date+1).to_s(:db)])
        my_account_logs << MyAccountLog.find_by_sql(["SELECT action from my_account_logs WHERE created_at >= ? AND created_at < ?", date.to_s(:db), (date+1).to_s(:db)])
        
      end

      OrdersMailer.deliver_ax_variance_report(weekly, orders, pfp_logs, ax_logs, erp_logs, my_account_logs)
    rescue
      msg = "Send AX/ERP Variance Report Failed! #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      `echo "#{msg}"|mail -s "#{msg}" #{AppConfig.DEBUG_EMAIL_ADDRESS}`
    end
  end
  
  desc "Website and AX/ERP inventories variance report."
  task :website_ax_inventories_variance => :environment do
    begin
      AxInventory.inventories_variance_report
    rescue
      msg = "Send Website and AX/ERP Inventories Variance Report Failed! #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      `echo "#{msg}"|mail -s "#{msg}" #{AppConfig.DEBUG_EMAIL_ADDRESS}`
    end
  end
end
