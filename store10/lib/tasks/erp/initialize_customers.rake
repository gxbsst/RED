require 'hpricot'

namespace :erp do
  desc "Sync AX/Website Order History/My Account - Execute via Cron"
  # This job should be executed *EVERY* 5 minutes to keep Order History in Sync
  task :sync => :environment do
    ['thread_pool', 'synchronizer'].each { |model| load "lib/tasks/erp/#{model}.rb" }
    ERP::Synchronizer.new( :threads => 2 ).sync
  end

  desc "Initialize ERP Customers"
  task :sync_all => :environment do
=begin
    date = Time.parse( '2007-01-01' ) # Set the start date to "2007-01-01"
    @customers = []
    
    while true
      nodes = parse_nodes( get_response( date ).body )
      @customers << nodes.collect { |node| node.innerHTML }
      puts "#{nodes.size} records fetched ..."
      date = date.months_since 1
      
      # The max length of response is 1,000 records.
      break if nodes.size < 1000
    end
    
    # Outputs
=end
    ['thread_pool', 'synchronizer'].each { |model| load "lib/tasks/erp/#{model}.rb" }
    ERP::Synchronizer.new( :threads => 5 ).sync :all
  end
end

# Query for the response of customers modified in the given month
def get_response( date )
  date_range = [parse_date( date ), parse_date( date.next_month )]
  puts "Getting records modified from #{date_range.join(' to ')} ..."
  
  response = ERP::ERPAgent.post(
    :url => AppConfig.SOAP_CU_SERV,
    :body => ERP::Customer.generate_xml( "find_entity_key_list_customers", :operator => "Range", :value1 => date_range.first, :value2 => date_range.last )
  )
end

def parse_nodes( xml )
  doc = Hpricot( xml )
  nodes = doc/'value'
end

def parse_date( time )
  time.strftime "%Y-%m-%d"
end
