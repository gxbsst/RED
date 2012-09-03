require "hpricot"

class ERP::Synchronizer
  
  include ERP::HelperMethods
  
  DEFAULT_OPTIONS = {
    :erp_start_time => "2007-01-01".to_time,
    :time_adjustment => 1.day,
    :max_try_times => 3,
    :threads => 1
  }.freeze
  
  def initialize(options={})
    @options = DEFAULT_OPTIONS.merge( options )
  end
  
  # Synchronize AX records to local
  # If no parameters given, it will INITIALIZE ALL records
  def sync( tag = nil )
    if tag == :all
      nodes = get_all_records
    else
      end_time = Time.now
      start_time = end_time - 20.day
      nodes = self.search_by_modified_date( start_time, end_time )
    end
    
    # TODO:
    #   1. Require a processing thread from ThreadPool
    #   2. Synchronize customer with given Account Num.
    #   3. Exception handler for each process. Serialize record if failed for severial times (Save to DB?)
    
    ERP::ThreadPool.new(@options[:threads], nodes).start do |customer_node|
      account_num = customer_node.search( 'AccountNum' ).inner_html
      output_log "Synchronizing customer \"#{account_num}\" ..."
      begin
        ERP::Customer.transaction do
          #sales_order = sales_orders.find_by_sales_id( sales_id ) || sales_orders.build( :sales_id => sales_id )
          #if sales_order.new_record? || ax_modstamp(node) > sales_order.erp_modstamp
          #BUG: 
          customer = ERP::Customer.find_by_account_num( account_num ) || ERP::Customer.new( :account_num => account_num )
          if customer.new_record? || ax_modstamp(customer_node) > customer.erp_modstamp
            output_log "#{account_num} Prepare to Sync Customer Account"
            customer.synchronize # recursively syncs sales orders and sales lines
          end
        end
      rescue => e
			  raise e
        output_log "#{account_num} synchronized failed!!!"
        unsynchronized_customer( account_num )
      end
    end
  end
  
  # private
  
  # Query for the account master records those modified during "start_date" and "end_date".
  # If block is given, "CustTable_1" nodes are accessible.
  # Note:
  #   To get integrated data from ax, the "START_DATE" will be modified according to parameter
  #   "DEFAULT_OPTIONS[:time_adjustment]".
  def search_by_modified_date( start_date, end_date )
    
    # Start Date Adjustment
    start_date -= @options[:time_adjustment]
    
    output_log "Querying customer master records modified during #{parse_date(start_date)} and #{parse_date(end_date)} ..."
    
    post_xml = ERP::Customer.generate_xml(
      "find_list_customers",
      :operator => "Range", :value1 => parse_date( start_date ), :value2 => parse_date( end_date )
    )
    
    tried_times = 0
    begin
      response = ERP::ERPAgent.post :url => AppConfig.SOAP_CU_SERV, :body => post_xml
    rescue => e
      if tried_times < @options[:max_try_times]
        tried_times += 1
        retry
      else
        output_log " !!! FAILED TO INITIALIZE DATA, PLEASE TRY AGAIN LATER !!!"
        raise e
      end
    end
    
    nodes = Hpricot.XML( response.body )/'CustTable_1'
    output_log "#{parse_date(start_date)} to #{parse_date(end_date)}, #{nodes.size} returned."
    
    # Block is given
    yield nodes if block_given?
    
    return nodes
  end
  
  # Query all account master records.
  def get_all_records
    nodes = []
    time_blocks = generate_time_blocks( DEFAULT_OPTIONS[:erp_start_time].dup, Time.now )
    
    # time_blocks.each do |pair|
    #   result = search_by_modified_date( pair.first, pair.last )
    #   nodes.concat result unless result.empty?
    # end
    
    ERP::ThreadPool.new(@options[:threads], time_blocks).start do |pair|
      sleep(1 * rand)
      result = search_by_modified_date( pair.first, pair.last )
      nodes.concat result unless result.empty?
    end
    
    output_log "#{nodes.size} records received!"
    return nodes
  end
  
  def generate_time_blocks( start_time, end_time, block=1.months)
    blocks = [[start_time, start_time + block]]
    
    while blocks.last.last < end_time
      blocks << [blocks.last.last, blocks.last.last + block]
    end
    
    return blocks
  end
  
  # Synchronized failed, save account number to database for restoring.
  def unsynchronized_customer( account_num )
    output_log account_num
  end
end
