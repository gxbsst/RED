require File.dirname(__FILE__) + '/../../test_helper'

class AxOrderTest < Test::Unit::TestCase
  def setup
    @http = stub(:request => stub(:is_a? => true, :code => 200, :body => sales_order_xml))
    @http.stubs(:use_ssl=)
    @http.stubs(:verify_mode=)
    
    @http_failed = stub(:request => stub(:is_a? => false, :code => 500, :body => request_failed_xml))
    @http_failed.stubs(:use_ssl=)
    @http_failed.stubs(:verify_mode=)
  end
  
  ##########################################
  # Test generate request xml
  ##########################################
  def test_generate_request_xml_successful
    assert AxOrder.request_xml("SO 0000001")
  end
  
  def test_generate_request_xml_exception_without_ax_order_number
    assert_raise ArgumentError do
      assert AxOrder.request_xml
    end
  end
  
  def test_generate_request_xml_exception_with_error_ax_order_number
    assert_raise RuntimeError do
      assert AxOrder.request_xml("Error Number")
    end
  end

  ###########################################
  # Initialize records for empty table
  ##########################################
  def test_init_records_as_default
    assert_equal 0, AxOrder.count
    AxOrder.init_records
    assert_equal AxOrder::INIT_RECORDS, AxOrder.count
  end
  
  def test_init_records_generate_by_speicify_range
    AxOrder.init_records(10)
    assert AxOrder.count == 10
    assert_equal "SO 0000001", AxOrder.find(:first).ax_order_number
    assert_equal "SO 0000010", AxOrder.maximum(:ax_order_number)
  end
  
  ##########################################
  # Calc next ax order number and sequence
  ##########################################
  def test_get_next_ax_order_number_begin_empty_table
    assert_equal "SO 0000001", AxOrder.next_ax_order_number
  end

  def test_get_next_ax_order_number
    AxOrder.init_records(15)
    assert_equal "SO 0000016", AxOrder.next_ax_order_number
  end
  
  def test_get_next_ax_order_number_by_specify_previous_number
    assert_equal "SO 0000011", AxOrder.next_ax_order_number("SO 0000010")
  end
  
  # Node:
  # Change begin "SO-0004242" at live
  # from "SO 0004241" to "SO-0004242"
  def test_get_next_ax_order_number_with_new_pattern
    assert_equal "SO 0004241", AxOrder.next_ax_order_number(4240)
    assert_equal "SO-0004242", AxOrder.next_ax_order_number(4241)
    assert_equal "SO-0004243", AxOrder.next_ax_order_number(4242)
  end
  
  ##########################################
  # Check number sequence
  ##########################################
  def test_check_ax_order_number_sequence
    AxOrder.init_records(5)
    assert AxOrder.check_ax_order_number_sequence
  end
  
  def test_check_ax_order_number_sequence_with_error_number
    AxOrder.create(:ax_order_number => "SO 0000001")
    AxOrder.create(:ax_order_number => "SO 0000010")
    assert !AxOrder.check_ax_order_number_sequence
  end
  
  def skiped_test_check_ax_order_number_sequence_if_first_number_not_restrict
    AxOrder.create(:ax_order_number => "SO 0000010")
    AxOrder.create(:ax_order_number => "SO 0000011")
    assert AxOrder.check_ax_order_number_sequence
  end
  
  ##########################################
  # Record Validation
  ##########################################
  def skip_test_record_valid
    # TODO: finish this test.
  end
  
  ##########################################
  # Update exist order data
  ##########################################
  def test_update_single_record
    Net::HTTP.stubs(:new).returns(@http)
    
    assert AxOrder.count == 0
    AxOrder.create(:ax_order_number => "SO 0000001")
    assert AxOrder.find(:first).ax_order_line_items.size == 0
    AxOrder.find(:first).update_record
    order = AxOrder.find(:first)
    assert_equal "101001", order.ax_order_line_items[0].item_id
    assert_equal "202002", order.ax_order_line_items[1].item_id

    AxOrder.find(:first).ax_order_line_items.each do |item|
      assert item
    end
  end
  
  def test_update_single_record_failed
    Net::HTTP.stubs(:new).returns(@http_failed)
    
    order = AxOrder.create(:ax_order_number => "SO 0000001")
    assert order.ax_order_line_items.size == 0
    AxOrder.update_records
    assert !AxOrder.find(:first).record_valid?
    #puts AxOrder.find(:first, :include => :ax_order_line_items).to_yaml
  end

  def test_batch_update_records
    Net::HTTP.stubs(:new).returns(@http)

    AxOrder.init_records(10)
    assert_equal 0, AxOrder.find(:all).inject(0) {|sum, i| sum + (i.record_valid? ? 1 : 0)}
    AxOrder.update_records
    assert_equal 10, AxOrder.find(:all).inject(0) {|sum, i| sum + (i.record_valid? ? 1 : 0)}
  end

  def test_batch_update_records_occur_http_failed
    Net::HTTP.stubs(:new).returns(@http,@http_failed,@http,@http_failed)

    AxOrder.init_records(10)
    AxOrder.update_records
    assert_equal 2, AxOrder.find(:all).inject(0) {|sum, i| sum + (i.record_valid? ? 1 : 0)}
  end

  ##########################################
  # Guest and fetch new order records
  ##########################################
  def test_append_records
    Net::HTTP.stubs(:new).returns(@http,@http,@http,@http,@http,@http,@http_failed)

    assert_equal 0, AxOrder.count
    AxOrder.append_records
    assert_equal 6, AxOrder.find(:all).size
    AxOrder.find(:all).each do |record|
      assert record.record_valid?
    end
    assert AxOrder.check_ax_order_number_sequence
  end

  ##########################################
  # Sync between website and ERP/AX
  ##########################################
  def test_sync
    #TODO:
  end

  private

  def sales_order_xml
    %(<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <soap:Body>
    <readSalesOrderResponse xmlns="http://schemas.microsoft.com/dynamics/2006/02/documents/SalesOrder">
      <SalesOrder>
        <SalesTable xmlns="http://schemas.microsoft.com/dynamics/2006/02/documents/SalesOrder" class="entity">
          <CreatedDate>2007-08-06</CreatedDate>
          <CustAccount>CU 0101757</CustAccount>
          <DeliveryCity>上海市</DeliveryCity>
          <DeliveryCountryRegionId>CN</DeliveryCountryRegionId>
          <DeliveryCounty>China</DeliveryCounty>
          <DeliveryDate>2007-09-06</DeliveryDate>
          <DeliveryState>上海</DeliveryState>
          <DeliveryStreet>方斜路,525弄,明华大厦2101室</DeliveryStreet>
          <DeliveryZipCode>200011</DeliveryZipCode>
          <ModifiedDate>2007-12-28</ModifiedDate>
          <PurchOrderFormNum>WEB872553604</PurchOrderFormNum>
          <SalesStatus>Backorder</SalesStatus>
          <SalesTax>1400.50</SalesTax>
          <ShippingCharges>400.50</ShippingCharges>
          <Discounts>2500.00</Discounts>
          <SalesLine class="entity">
            <ConfirmedDlv>2007-09-06</ConfirmedDlv>
            <DeliveredInTotal>2.00</DeliveredInTotal>
            <InvoicedInTotal>2.00</InvoicedInTotal>
            <ItemId>101001</ItemId>
            <RemainSalesPhysical>1.00</RemainSalesPhysical>
            <SalesItemReservationNumber>026</SalesItemReservationNumber>
            <SalesQty>2.00</SalesQty>
            <SalesUnit>Ea</SalesUnit>
          </SalesLine>
          <SalesLine class="entity">
            <ConfirmedDlv>2007-09-06</ConfirmedDlv>
            <DeliveredInTotal>2.00</DeliveredInTotal>
            <InvoicedInTotal>2.00</InvoicedInTotal>
            <ItemId>202002</ItemId>
            <RemainSalesPhysical>2.00</RemainSalesPhysical>
            <SalesItemReservationNumber>025</SalesItemReservationNumber>
            <SalesQty>2.00</SalesQty>
            <SalesUnit>Ea</SalesUnit>
          </SalesLine>
        </SalesTable>
      </SalesOrder>
    </readSalesOrderResponse>
  </soap:Body>
</soap:Envelope>)
  end

  def request_failed_xml
    %(<?xml version='1.0' encoding='UTF-8'?>
<soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
  <soap:Body>
    <soap:Fault>
      <soap:Code>
        <soap:Value>soap:Sender</soap:Value>
      </soap:Code>
      <soap:Reason>
        <soap:Text xml:lang='en'>Request Failed. See the Exception Log for details.</soap:Text>
      </soap:Reason>
      <soap:Node>https://axobj.red.local/DynamicsWebService/SalesOrderService.asmx</soap:Node>
      <soap:Detail/>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>)
  end
end
