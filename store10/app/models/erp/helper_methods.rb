module ERP::HelperMethods
  
  def self.included(klass)
    klass.extend( ClassMethods )
  end
  
  # Class Methods
  module ClassMethods

    def find_account_num(erp_object)
      class_name = erp_object.class.name
      if class_name == 'ERP::Customer'
        return erp_object.account_num
      elsif class_name == 'ERP::SalesOrder'
        return erp_object.customer.account_num
      elsif class_name == 'ERP::SalesLine'
        return erp_object.sales_order.customer.account_num
      elsif class_name == 'ERP::ContactPerson'
        return erp_object.customer.account_num
      elsif class_name == 'ERP::CustomerAddress'
        return erp_object.customer.account_num
      elsif class_name == 'ERP::InvoiceAddress' || class_name == 'ERP::DeliveryAddress'
        return erp_object.sales_order.customer.account_num
      else
        raise "Unknown ERP Object %{erp_object.class} - Add this type to ERPSupport, erp_account_num"
      end
    end

    def find_order_num(erp_object)
      class_name = erp_object.class.name
      if class_name == 'ERP::SalesOrder'
        return erp_object.sales_id
      elsif class_name == 'ERP::SalesLine'
        return erp_object.sales_order.sales_id
      elsif class_name == 'ERP::InvoiceAddress' || class_name == 'ERP::DeliveryAddress'
        return erp_object.sales_order.sales_id
      end
    end
    
  end

  def zero_time
    return Time.gm(1970,1,1,0,0,1)
    # return Time.at(0) # Time Zone Issues with Time.at -- too much trouble...
  end
  
  
  private
  
  def parse_date( date_time )
    date_time.strftime "%Y-%m-%d"
  end
  
  def output_log( text )
    print "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{text} \n"
  end
	
  def ax_modstamp( node )
    ax_modtime = node.search("/ModifiedTime").inner_text
    ax_moddate = node.search("/ModifiedDate").inner_text
    if ax_modtime == "00:00:00" && ax_moddate.blank?
      return zero_time
    elsif ax_modtime.blank? && ax_moddate.blank?
      return zero_time
    else
      return Time.parse(ax_moddate + " " + ax_modtime)
    end
  end
  

end
