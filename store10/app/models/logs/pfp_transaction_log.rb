class PfpTransactionLog < ActiveRecord::Base

  #===========================================
  # log message request to pfp serv
  #===========================================
  def self.build(params)
    return create( {:status => 'REQUEST'}.merge(params) )
  end
  
  #===========================================
  # log message receipt from pfp serv 
  #===========================================
  def complete(params)
    update_attributes( {:status => "UPDATE"}.merge(params) )
  end
  
  #===========================================
  # log message when pfp serv exception
  #===========================================
  def exception(params)
    update_attributes(
      {
        :res_message => "Exception",
        :status      => 'EXCEPTION'
      }.merge(params)
    )
  end

  # Parse req_xml and return result as hash.
  def request
    result = {}
    req_xml.blank? ? xml = '' : xml = req_xml
    doc = Hpricot.XML(xml)
    (doc/:RequestAuth/:UserPass/:User).inner_html = 'XXXXXXXX'
    (doc/:RequestAuth/:UserPass/:Password).inner_html = 'XXXXXXXX'
    result[:xml]     = ErpHelper.xml2html(doc.to_s)
    result[:street]  = (doc/:BillTo/:Address/:Street).inner_text
    result[:city]    = (doc/:BillTo/:Address/:City).inner_text
    result[:state]   = (doc/:BillTo/:Address/:State).inner_text
    result[:zip]     = (doc/:BillTo/:Address/:Zip).inner_text
    result[:country] = (doc/:BillTo/:Address/:Country).inner_text
    result[:amount]  = (doc/:PayData/:Invoice/:TotalAmt).inner_text
    result[:safe_cc_number]   = (doc/:Tender/:Card/:CardNum).inner_text
    result[:expiration_date]  = (doc/:Tender/:Card/:ExpDate).inner_text
    result[:expiration_year]  = result[:expiration_date][-4,2]
    result[:expiration_month] = result[:expiration_date][-2,2]
    return result
  end

  # Parse res_xml and return result as hash.
  def response
    result = {}
    res_xml.blank? ? xml = '' : xml = res_xml
    doc = Hpricot.XML(xml)
    case status
    when 'REQUEST'
      result[:status] = 'BEGIN'
    when 'UPDATE'
      result[:status] = 'NORMAL'
    when 'EXCEPTION'
      result[:status] = 'ERROR'
    end
    result[:xml]         = ErpHelper.xml2html(doc.to_s)
    case (doc/:IAVSResult).inner_text
    when 'Y'
      result[:avsresult] = 'Match'
    when 'N'
      result[:avsresult] = 'No Match'
    when 'X'
      result[:avsresult] = 'No Provide'
    end
    result[:zipmatch]    = (doc/:AVSResult/:ZipMatch).inner_text
    result[:streetmatch] = (doc/:AVSResult/:StreetMatch).inner_text
    pfp_res_code_msg = open(RAILS_ROOT+"/db/pfp_transaction_result_code_and_message.yml") {|f| YAML.load(f)}
    pfp_res_code_msg[res_code].blank? ? result[:pfp_res_code_msg] = 'Credit Card Processing Gateway Error.' : result[:pfp_res_code_msg] = pfp_res_code_msg[res_code]
    return result
  end
  
end
