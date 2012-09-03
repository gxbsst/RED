class AxOrder < ActiveRecord::Base
  require 'erp/thread_pool'
  
  belongs_to :ax_account, :conditions => ['status <> ?', 'ERROR']
  has_many   :ax_order_line_items

  # Set fill in number of empty records at table begin.
  INIT_RECORDS = 4780

  # Variable just for set number before order number pattern change.
  # Change begin "SO-0004242"
  # from "SO 0004241" to "SO-0004242"
  NEW_NUMBER_PATTERN = 4242

  # Set max size of container for temporary fetch and save orders.
  MAX_COUNTER = 10

  # Class method begin here:
  class << self
    # append new records and updata all exist records
    def sync
      init_records
      
      # sync with AX up to date.
      append_records

      # update all records in single process.
      update_records

      # Update all records concurrency.
      #update_all
    end

    def init_records(range = nil)
      # exit when tables has esists records.
      return unless count == 0

      range ||= INIT_RECORDS    # fill default number records.
      raise TypeError unless range.is_a?(Fixnum)
      records = []
      range.times {|i| records << "('#{next_ax_order_number(i)}')"}
      connection.execute "INSERT INTO #{table_name} (ax_order_number) VALUES#{records.join(",")}"
    end

    # sync with AX up to date.
    def append_records
      # counter is a array type container hold numbers of AxOrder instance.
      # current AxOrder instance by manipulate is last member of container.
      counter = []
      begin
        if counter.empty?
          counter << new(:ax_order_number => next_ax_order_number)
        else
          counter << new(:ax_order_number => next_ax_order_number(counter.last.ax_order_number))
        end

        order, items = counter.last.fetch_data
        counter.last.attributes = order
        items.each do |item|
          counter.last.ax_order_line_items << AxOrderLineItem.new(item)
        end
        counter.each {|o| o.save }
        append_records  # recursive invoke method self
      rescue => ex
        puts ex.message if AppConfig.DEBUG_MODE
        retry unless counter.size == MAX_COUNTER
      end
    end

    # update all records in single process.
    def update_records(range = nil)
      find(:all).each do |record|
        record.update_record
      end
    end
    
    # Update all records concurrency.
    def update_all
      pool = ThreadPool.new(5)
      
      find(:all).each do |record|
        pool.process do
          begin
            rcd = record
            rcd.update_record
          rescue => ex
            # mark record status to "500 ERROR".
            # if successful update at previous, just skip it.
            rcd.update_attribute(:status, "ERROR")
          ensure
            # clear out old connections.
            ActiveRecord::Base.verify_active_connections!
          end
        end
      end
    end

    def next_ax_order_number(current_number = nil)
      case
      when current_number.blank? && count == 0 then current_number = 0
      when current_number.blank? && count != 0 then current_number = maximum(:ax_order_number)
      end

      number = current_number.to_s.gsub(/\D/, "").to_i
      ((number+1) >= NEW_NUMBER_PATTERN ? "SO-" : "SO ") << sprintf("%07d", number.next)
    end

    def check_ax_order_number_sequence
      case
      when count <= 1 then return true  # empty or only one record in table.
      when count == 2                # only two records in table.
        records = self.find(:all, :order => 'id ASC')
        return false unless records.first.ax_order_number == next_ax_order_number(0) # commit if the first number isn't restrict.
        return false unless records.last.ax_order_number == next_ax_order_number(records.first.ax_order_number)
      else # more than two records.
        numbers = AxOrder.find(:all).collect(&:ax_order_number)
        (1...count).each do |i|
          return false unless next_ax_order_number(numbers[i-1]) == numbers[i]
        end
      end

      return true
    end

    def httpagent(options)
      options = {
        :iis_user     => AppConfig.IIS_USER,
        :iis_pass     => AppConfig.IIS_PASS,
        :url          => AppConfig.SOAP_SO_SERV,
        :content_type => "application/soap+xml; charset=utf-8;",
        :body         => ""
      }.merge(options)
      
      # Print request body out to STDOUT
      ErpHelper.logger(options[:body]) if AppConfig.DEBUG_MODE

      uri = URI.parse(options[:url])
      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(options[:iis_user], options[:iis_pass])
      request.set_content_type(options[:content_type])
      request.body = options[:body]
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      response = http.request(request)

      # Puts response body out to STDOUT.
      if AppConfig.DEBUG_MODE
        ErpHelper.logger("HTTP Response Code: #{response.code}", 'purple')
        ErpHelper.logger("HTTP Response Is a HTTPSuccess: #{response.is_a?(Net::HTTPSuccess).to_s}", 'purple')
        ErpHelper.logger(response.body, "purple")
      end

      raise unless response.is_a? Net::HTTPSuccess

      return response
    end

    def request_xml(ax_order_number)
      # ax_order_number pattern as "SO 0000001" ro "SO-0000001"
      unless !ax_order_number.blank? && ax_order_number.match(/^SO[\s|-][0-9]{7}$/)
        raise RuntimeError, "Ax order number pattern can't match!"
      end

      xml = ""
      doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
      doc.instruct!
      doc.soap12:Envelope,
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
        "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
        doc.soap12 :Body do
          doc.readSalesOrder :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/SalesOrder" do
            doc.DocumentContext do
              doc.MessageId( UUID.random_create.to_s )
              doc.SourceEndpointUser( AppConfig.SOAP_USER )
              doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
              doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
            end
            doc.EntityKey :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/EntityKey" do
              doc.KeyData do
                doc.KeyField do
                  doc.Field( "SalesId" )
                  doc.Value( ax_order_number )
                end
              end
            end
          end
        end
      end
    end
  end

  # Instance method begin here:

  def fetch_data
    xml = AxOrder.httpagent(:body => AxOrder.request_xml(ax_order_number)).body
    doc = Hpricot.XML(xml)

    order = {
      :ax_account_id              => find_ax_account_id((doc/:CustAccount).inner_text),
      :ax_account_number          => (doc/:CustAccount).inner_text,
      :delivery_city              => (doc/:DeliveryCity).inner_text,
      :delivery_country_region_id => (doc/:DeliveryCountryRegionId).inner_text,
      :delivery_county            => (doc/:DeliveryCounty).inner_text,
      :delivery_date              => (doc/:DeliveryDate).inner_text,
      :delivery_state             => (doc/:DeliveryState).inner_text,
      :delivery_street            => (doc/:DeliveryStreet).inner_text,
      :delivery_zip_code          => (doc/:DeliveryZipCode).inner_text,
      :purch_order_form_num       => (doc/:PurchOrderFormNum).inner_text,
      :sales_tax                  => (doc/:SalesTax).inner_text,
      :shipping_charges           => (doc/:ShippingCharges).inner_text,
      :discounts                  => (doc/:Discounts).inner_text,
      :created_date               => (doc/:CreatedDate).inner_text,
      :modified_date              => (doc/:ModifiedDate).inner_text,
      :sales_status               => (doc/:SalesStatus).inner_text,
      :status                     => "UPDATE"
    }

    items = []
    (doc/:SalesLine).each do |sales_line|
      items << {
        :ax_order_number               => ax_order_number,
        :confirmed_lv                  => (sales_line/:ConfirmedDlv).inner_text,
        :delivered_in_total            => (sales_line/:DeliveredInTotal).inner_text,
        :invoiced_in_total             => (sales_line/:InvoicedInTotal).inner_text,
        :item_id                       => (sales_line/:ItemId).inner_text,
        :remain_sales_physical         => (sales_line/:RemainSalesPhysical).inner_text,
        :sales_item_reservation_number => (sales_line/:SalesItemReservationNumber).inner_text,
        :sales_qty                     => (sales_line/:SalesQty).inner_text,
        :sales_unit                    => (sales_line/:SalesUnit).inner_text
      }
    end

    return order, items
  end

  def update_record
    begin
      order, items = fetch_data

      # erasure exists date before update
      erasure_record
      
      self.attributes = order

      items.each do |item|
        ax_order_line_items << AxOrderLineItem.new(item)
      end

      save
    rescue
      # if current record is new create or never update before,
      # mark record status column value "500 ERROR".
      # if successful update at previous, just skip it.
      self.update_attribute(:status, "ERROR")
      return false
    end
  end

  def find_ax_account_id(ax_account_number)
    account = AxAccount.find_by_ax_account_number(ax_account_number)
    account.blank? ? nil : account.id
  end

  # purge data before update
  def erasure_record
    ax_order_line_items.destroy_all unless ax_order_line_items.blank?
    self.update_attributes(
      :ax_account_id              => "",
      :ax_account_number          => "",
      :delivery_city              => "",
      :delivery_country_region_id => "",
      :delivery_county            => "",
      :delivery_date              => "",
      :delivery_state             => "",
      :delivery_street            => "",
      :delivery_zip_code          => "",
      :purch_order_form_num       => "",
      :sales_tax                  => 0.0,
      :shipping_charges           => 0.0,
      :discounts                  => 0.0,
      :sales_status               => "",
      :status                     => "ERASURED"
    )
  end
  
  # validation methods
  def record_valid?
    [
      :ax_order_number,
      :ax_account_number,
      #:deliver_city,
      #:deliver_country_region_id,
      #:deliver_county,
      #:deliver_date,
      #:deliver_state,
      #:deliver_street,
      #:deliver_zip_code,
      #:purch_order_form_num,
      #:ax_order_line_items
    ].each do |attr|
      if self.send(attr).blank?
        errors.add attr, "#{attr.to_s} can't be blank"
      end
    end

    errors.empty?
  end
  
  # method for business
  def complete_subtotal
    ax_order_line_items.blank? ? 0.0 : ax_order_line_items.map(&:subtotal).inject(&:+)
  end
  
  def redone_total
    count = ax_order_line_items.select{|item| item.item_id == Product::REDONE_ERP_PRODUCT_ITEM }.map(&:sales_quantity).inject(&:+)
    count.blank? ? 0 : count
  end

  # Check account and account's email address of this order
  def prepare_delivery_validation
    if self.ax_account.blank?
      return "\"#{ax_account_number}\",\"#{ax_order_number}\",\"Account record not exists\""
    end
    
    # validate ax_account like email_address...
    if self.ax_account.email_address.blank?
      return "\"#{ax_account_number}\",\"#{ax_order_number}\",\"Email address not exists, name: #{ax_account.name}\""
    end
  end

  def purchase_from_xfer?
    self.purch_order_form_num.match('WIRE')
  end

  # --- short-circuit methods begin --- #
  def email_address
    account = self.ax_account
    account.blank? ? "" : account.email_address
  end
  
  def first_name
    account = self.ax_account
    account.blank? ? "" : account.first_name
  end
  
  def last_name
    account = self.ax_account
    account.blank? ? "" : account.last_name
  end

  def name
    account = self.ax_account
    account.blank? ? "" : account.name
  end
  
  def invoice_country_region_id
    if ax_account
      ax_account.invoice_country_region_id
    else
      ""
    end
  end
  
  def delivery_country_region_id
    if ax_account
      ax_account.delivery_country_region_id
    else
      self["delivery_country_region_id"]
    end 
  end
  # --- short-circuit methods end --- #
end
