module ERP::HelperMethods
  
  private
  
  def parse_date( date_time )
    date_time.strftime "%Y-%m-%d"
  end
  
  def output_log( text )
    print "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{text} \n"
  end
  
end