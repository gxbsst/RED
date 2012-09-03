# rake tasks for RED.com and the AX/ERP synchronizer
namespace :ax do
  def fslock(lock_file='ax_sync.lock')
    # detect or create exclusive file lock
    if File.file? lock_file
      pid = open(lock_file) {|f| f.read}

      if Dir.entries('/proc').include? pid
        print "\n  Synchronizer are in process...\n\n"
        exit 0
      end
    else
      open(lock_file, 'w') {|f| f << Process.pid.to_s}
    end

    begin
      yield if block_given?
    rescue
      #TODO:
    ensure
      FileUtils.rm lock_file if File.file? lock_file
    end
  end

  
  desc 'Hourly sync website and the AX/ERP.'
  task :hourly => :environment do
    fslock("ax_sync_hourly.lock") do
      # Set ActiveRecord use connection pre-thread.
      #ActiveRecord::Base.allow_concurrency = true
    
      Rake::Task['ax:sync:accounts'].invoke
      Rake::Task['ax:sync:orders'].invoke
      Rake::Task['ax:sync:redone_serial_number'].invoke
      Rake::Task['ax:sync:webaccount_purchased'].invoke
      Rake::Task['ax:sync:blast_redone_serial_number_notify_mails'].invoke
    end
  end
  
  desc 'Daily sync website and the AX/ERP.'
  task :daily => :environment do
    fslock("ax_sync_daily.lock") do
      Rake::Task['ax:sync:inventory'].invoke
      Rake::Task['ax:sync:shipping_rate'].invoke
    end
  end

  namespace :sync do
    desc 'Sync the AX/ERP accounts.'
    task :accounts => :environment do
      AxAccount.sync
    end
    
    desc 'Sync the AX/ERP orders.'
    task :orders => :environment do
      AxOrder.sync
    end
    
    desc 'Sync the AX/ERP RedOne Serial Number'
    task :redone_serial_number => :environment do
      RedoneSerialNumber.sync
    end
    
    desc 'Update WebAccount.purchased is true'
    task :webaccount_purchased => :environment do
      red_one_shipped_account_numbers = AxAccount.find(:all, :conditions => ['red_one_shipped = ?', "Yes"]).map!(&:ax_account_number)
      StoreUser.find(:all).each do |store_user|
        if red_one_shipped_account_numbers.include? store_user.erp_account_number
          store_user.update_attributes(:purchased => true) unless store_user.purchased
        end
      end
    end
    
    desc 'Blast RedOne Serial(s) Notify mails'
    task :blast_redone_serial_number_notify_mails => :environment do
      MailTaskRedoneSerialNumberNotifyQueue.blast
    end
    
    desc 'Sync the AX/ERP inventory.'
    task :inventory => :environment do
      AxInventory.sync
    end

    desc 'Sync the AX/ERP shipping rate.'
    task :shipping_rate => :environment do
      AxShippingRate.sync
    end
  end
end
