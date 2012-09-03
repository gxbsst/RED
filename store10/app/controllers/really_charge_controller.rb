class ReallyChargeController < ApplicationController
  require "net/http"
  require "net/https"
  require 'uri'
  require "erb"
  include ERB::Util
  include OrderHelper
  def index

    log_string = ''
    Order.find(:all, :conditions => 'order_status_code_id = 2', :limit => 10).each do | order |
    amount = order.total * 0.1
    cc_num = order.account.cc_number
    ccv2 = order.account.credit_ccv
    exp_month = sprintf("%02d", order.account.expiration_month)
    exp_year  = (sprintf("%02d", order.account.expiration_year))[-2,2]
    exp = exp_month + exp_year
    street_address = url_encode(order.billing_address.address)
    zip = order.billing_address.zip

    viaklix = viaklix( amount, cc_num, exp, ccv2, street_address, zip, 0)

    order.transaction_id = viaklix['ssl_txn_id']
    order.authorization_code = viaklix['ssl_approval_code']

    if viaklix['ssl_result'] == "0"
      order.order_status_code_id = 1
      OrdersMailer.deliver_receipt(order)
    else
      order.order_status_code_id = 3
    end

    order.save

    log_string << "#{order.id} #{viaklix['ssl_result_message']}<br>"
    end

    render :text => log_string
  end

  private
  def viaklix(amount, card, exp, cvv2, address, zip, test)
    http = Net::HTTP.new('www.viaklix.com', 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    path = "/process.asp"
    user_agent = "RubyViaKlix/1.0" #Sometimes there is trouble without a user agent defined
    data = "ssl_test_mode=#{test}&" +
        "ssl_amount=#{amount}&ssl_merchant_id=408748&ssl_user_id=website&" +
        "ssl_show_form=false&ssl_pin=SB1TQR&ssl_card_number=#{card}&" +
        "ssl_exp_date=#{exp}&ssl_customer_code=1&ssl_result_format=ASCII&" +
        "ssl_salestax=0&ssl_cvv2=#{cvv2}&ssl_avs_address=#{address}&ssl_avs_zip=#{zip}"
        headers = {
            'Content-Type' => 'application/x-www-form-urlencoded',
            'Referer' => 'https://www.red.com',
            'User-Agent' => 'Red_Digital_Cinema/1.0'
        }

        response = http.post2(path, data, headers)
        rows = response.body.split("\r\n")
        data = {}
        rows.each do |r|
          key_val = r.split("=")
          data[key_val[0]] = key_val[1]
        end
        return data
  end

end
