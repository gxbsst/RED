require File.dirname(__FILE__) + '/../../test_helper'

class AxAccountTest < Test::Unit::TestCase
  
  def setup
    @http = stub(:request => stub(:is_a? => true, :code => 200, :body => read_account_response_xml))
    @http.stubs(:use_ssl=)
    @http.stubs(:verify_mode=)
    
    @http_failed = stub(:request => stub(:is_a? => false, :code => 500, :body => request_failed_xml))
    @http_failed.stubs(:use_ssl=)
    @http_failed.stubs(:verify_mode=)
  end
  
  ###########################################
  # Test generate request xml
  ##########################################
  def test_generate_request_xml_successful
    assert AxAccount.request_xml("CU 0100000")
  end

  def test_generate_request_xml_without_customer_number
    assert_raise ArgumentError do
      AxAccount.request_xml
    end
  end
  
  def test_generate_request_xml_without_formal_number_format
    assert_raise RuntimeError do
      AxAccount.request_xml("Error Number")
    end
  end
  
  ##########################################
  # Calc next ax account number and sequence
  ##########################################
  def test_next_ax_account_number_begining
    assert_equal "CU 0100001", AxAccount.next_ax_account_number
  end
  
  def test_next_ax_account_number
    AxAccount.init_records(5)
    assert_equal "CU 0100006", AxAccount.next_ax_account_number
  end
  
  def test_next_ax_account_number_by_specify_previous_number
    AxAccount.init_records(5)
    assert_equal "CU 0100011", AxAccount.next_ax_account_number("CU 0100010")
  end
  
  def test_check_ax_account_number_sequence_for_only_two_records
    AxAccount.init_records(2)
    assert AxAccount.check_ax_account_number_sequence
  end
  
  def test_check_ax_account_number_sequence_for_batch_check
    AxAccount.init_records(5)
    assert AxAccount.check_ax_account_number_sequence
  end
  
  ##########################################
  # Initialize records for empty table
  ##########################################
  def test_init_records_as_default
    assert_equal 0, AxAccount.count
    AxAccount.init_records
    assert_equal AxAccount::INIT_RECORDS, AxAccount.count
  end
  
  def test_init_records_generate_by_speicify_numbers
    AxAccount.init_records(10)
    assert AxAccount.count == 10
    assert_equal "CU 0100001", AxAccount.find(:first).ax_account_number
    assert_equal "CU 0100010", AxAccount.maximum(:ax_account_number)
  end
  
  ##########################################
  # Ax account validation
  ##########################################
  def test_ax_account_validation
    account = AxAccount.create
    assert !account.record_valid?
    account.errors.clear
    account.attributes = {
      :ax_account_number   => "CU 0100001",
      :address             => "Test",
      :currency            => "Test",
      :cust_group          => "Test",
      :cust_first_name     => "Test",
      :cust_last_name      => "Test",
      :email               => "Test",
      :language_id         => "Test"
    }
    assert account.record_valid?
  end
  
  ##########################################
  # Update exist account data
  ##########################################
  def test_update_single_record
    Net::HTTP.stubs(:new).returns(@http)
    
    account = AxAccount.create(:ax_account_number => "CU 0100001")
    assert account.update_record
    assert AxAccount.find(:first)
    
    assert_equal 2, AxAccount.find(:first).ax_account_addresses.size
    AxAccount.find(:first).ax_account_addresses.each do |addr|
      assert addr
    end
    
    assert_equal 1, AxAccount.find(:first).ax_account_contact_people.size
    AxAccount.find(:first).ax_account_contact_people.each do |person|
      assert person
    end
    
    assert !AxAccount.find(:first).invoice_address.blank?
    assert !AxAccount.find(:first).invoice_city.blank?
    assert !AxAccount.find(:first).invoice_country_region_id.blank?
    assert !AxAccount.find(:first).invoice_state.blank?
    assert !AxAccount.find(:first).invoice_street.blank?
    assert !AxAccount.find(:first).delivery_address.blank?
    assert !AxAccount.find(:first).delivery_city.blank?
    assert !AxAccount.find(:first).delivery_country_region_id.blank?
    assert !AxAccount.find(:first).delivery_state.blank?
    assert !AxAccount.find(:first).delivery_street.blank?
  end
  
  def test_update_single_record_failed
    Net::HTTP.stubs(:new).returns(@http_failed)
    
    AxAccount.create(:ax_account_number => "CU 0100001")
    AxAccount.update_records
    assert !AxAccount.find(:first).record_valid?
  end
  
  def test_batch_update_records
    Net::HTTP.stubs(:new).returns(@http)

    AxAccount.init_records(10)
    assert_equal 0, AxAccount.find(:all).inject(0) {|sum, i| sum + (i.record_valid? ? 1 : 0)}
    AxAccount.update_records
    assert_equal 10, AxAccount.find(:all).inject(0) {|sum, i| sum + (i.record_valid? ? 1 : 0)}
  end

  def test_batch_update_records_occur_http_failed
    Net::HTTP.stubs(:new).returns(@http,@http_failed,@http,@http_failed)

    AxAccount.init_records(10)
    AxAccount.update_records
    assert_equal 2, AxAccount.find(:all).inject(0) {|sum, i| sum + (i.record_valid? ? 1 : 0)}
  end
  
  ##########################################
  # Guest and fetch new order records
  ##########################################
  def test_append_records
    Net::HTTP.stubs(:new).returns(@http,@http,@http,@http,@http,@http,@http_failed)

    assert_equal 0, AxAccount.count
    AxAccount.append_records
    assert_equal 6, AxAccount.count
    AxAccount.find(:all).each do |record|
      assert record.record_valid?
    end
    assert AxAccount.check_ax_account_number_sequence
  end
  
  private

  def read_account_response_xml
    %(<?xml version='1.0' encoding='UTF-8'?>
<soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
  <soap:Body>
    <readCustomersResponse xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/Customers'>
      <Customers>
        <CustTable_1 class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/Customers'>
          <AccountBalance>5592.20</AccountBalance>
          <Address>address</Address>
          <City>city</City>
          <CountryRegionId>reginn_id</CountryRegionId>
          <CreatedDate>2007-08-06</CreatedDate>
          <Currency>USD</Currency>
          <CustFirstName>First</CustFirstName>
          <CustGroup>DOM</CustGroup>
          <CustLastName>last</CustLastName>
          <Discounts>2500.00</Discounts>
          <Email>test@test.com</Email>
          <LanguageId>EN-US</LanguageId>
          <ModifiedDate>2007-10-19</ModifiedDate>
          <State>CA</State>
          <Phone>1234567890</Phone>
          <RedOneShipped>Yes</RedOneShipped>
          <Street>street</Street>
          <TeleProdTaxExempt>No</TeleProdTaxExempt>
          <ZipCode>PE85DQ</ZipCode>
          <ContactPerson_1 class='entity'>
            <Email>d.higgs@btclick.com</Email>
            <FirstName>David</FirstName>
            <LastName>Higgs</LastName>
            <Name>contact_person_name</Name>
            <selectedAddress>contact_person_select_address</selectedAddress>
          </ContactPerson_1>
          <Address_1 class='entity'>
            <Address>invoice address</Address>
            <City>invoice city</City>
            <CountryRegionId>invoice region id</CountryRegionId>
            <State>invoice state</State>
            <Street>invoice street</Street>
            <type>Invoice</type>
          </Address_1>
          <Address_1 class='entity'>
            <Address>delivery address</Address>
            <City>delivery city</City>
            <CountryRegionId>delivery region id</CountryRegionId>
            <State>delivery state</State>
            <Street>delivery street</Street>
            <type>Delivery</type>
          </Address_1>
        </CustTable_1>
      </Customers>
    </readCustomersResponse>
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
      <soap:Node>https://axobj.red.local/DynamicsWebService/CustomersService.asmx</soap:Node>
      <soap:Detail/>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>)
  end

end
