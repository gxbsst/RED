require File.dirname(__FILE__) + '/../../test_helper'

class AxShippingRateTest < Test::Unit::TestCase
  def setup
    @http = stub(:request => stub(:is_a? => true, :code => 200, :body => response_xml))
    @http.stubs(:use_ssl=)
    @http.stubs(:verify_mode=)
    
    @http_failure = stub(:request => stub(:is_a? => false, :code => 500, :body => request_failed_xml))
    @http_failure.stubs(:use_ssl=)
    @http_failure.stubs(:verify_mode=)
  end
  
  def test_generate_request_xml
    AxShippingRate::SHIPPING_ZONE_RANGES.each do |shipping_zone|
      assert !AxShippingRate.request_xml(shipping_zone).blank?
    end
  end
  
  def test_create_or_update_records_for_single_shipping_zone
    Net::HTTP.stubs(:new).returns(@http)
    
    AxShippingRate.create_or_update_records('C')
    assert_equal response_xml_shipping_rates_count, AxShippingRate.count
    
    # double execute wouldn't create redundance records
    AxShippingRate.create_or_update_records('C')
    assert_equal response_xml_shipping_rates_count, AxShippingRate.count
  end
  
  def test_create_or_update_all_ranges_of_shipping_zone_records
    Net::HTTP.stubs(:new).returns(@http)
    
    AxShippingRate.sync
    assert_equal response_xml_shipping_rates_count * AxShippingRate::SHIPPING_ZONE_RANGES.to_a.size, AxShippingRate.count
  end
  
  def test_sync_under_network_fail_conditions
    
  end
  
  private
  
  def response_xml
    %(<?xml version='1.0' encoding='UTF-8'?>
<soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
  <soap:Body>
    <findListShippingRatesResponse xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
      <ShippingRates>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>1.00</MaxPoints>
          <RetailPrice>58.80</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>5.00</MaxPoints>
          <MinPoints>1.10</MinPoints>
          <RetailPrice>93.96</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>10.00</MaxPoints>
          <MinPoints>5.10</MinPoints>
          <RetailPrice>129.34</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>15.00</MaxPoints>
          <MinPoints>10.10</MinPoints>
          <RetailPrice>153.76</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>20.00</MaxPoints>
          <MinPoints>15.10</MinPoints>
          <RetailPrice>178.20</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>25.00</MaxPoints>
          <MinPoints>20.10</MinPoints>
          <RetailPrice>202.64</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>30.00</MaxPoints>
          <MinPoints>25.10</MinPoints>
          <RetailPrice>224.00</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>40.00</MaxPoints>
          <MinPoints>30.10</MinPoints>
          <RetailPrice>243.85</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>50.00</MaxPoints>
          <MinPoints>40.10</MinPoints>
          <RetailPrice>265.85</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>60.00</MaxPoints>
          <MinPoints>50.10</MinPoints>
          <RetailPrice>283.96</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>70.00</MaxPoints>
          <MinPoints>60.10</MinPoints>
          <RetailPrice>305.75</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>80.00</MaxPoints>
          <MinPoints>70.10</MinPoints>
          <RetailPrice>320.00</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>90.00</MaxPoints>
          <MinPoints>80.10</MinPoints>
          <RetailPrice>338.75</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIE</Code>
          <MaxPoints>100.00</MaxPoints>
          <MinPoints>90.10</MinPoints>
          <RetailPrice>357.50</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>1.00</MaxPoints>
          <RetailPrice>61.56</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>5.00</MaxPoints>
          <MinPoints>1.10</MinPoints>
          <RetailPrice>99.69</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>10.00</MaxPoints>
          <MinPoints>5.10</MinPoints>
          <RetailPrice>140.63</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>15.00</MaxPoints>
          <MinPoints>10.10</MinPoints>
          <RetailPrice>170.63</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>20.00</MaxPoints>
          <MinPoints>15.10</MinPoints>
          <RetailPrice>196.35</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>25.00</MaxPoints>
          <MinPoints>20.10</MinPoints>
          <RetailPrice>210.94</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>30.00</MaxPoints>
          <MinPoints>25.10</MinPoints>
          <RetailPrice>237.50</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>40.00</MaxPoints>
          <MinPoints>30.10</MinPoints>
          <RetailPrice>263.75</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>50.00</MaxPoints>
          <MinPoints>40.10</MinPoints>
          <RetailPrice>300.94</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>60.00</MaxPoints>
          <MinPoints>50.10</MinPoints>
          <RetailPrice>332.81</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>70.00</MaxPoints>
          <MinPoints>60.10</MinPoints>
          <RetailPrice>363.13</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>80.00</MaxPoints>
          <MinPoints>70.10</MinPoints>
          <RetailPrice>391.25</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>90.00</MaxPoints>
          <MinPoints>80.10</MinPoints>
          <RetailPrice>412.19</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
        <ShippingRateTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/ShippingRates'>
          <Code>FdxIP</Code>
          <MaxPoints>100.00</MaxPoints>
          <MinPoints>90.10</MinPoints>
          <RetailPrice>435.00</RetailPrice>
          <ShippingZone>C</ShippingZone>
        </ShippingRateTable>
      </ShippingRates>
    </findListShippingRatesResponse>
  </soap:Body>
</soap:Envelope>)
  end

  def response_xml_shipping_rates_count
    @shipping_rates_count ||= Hpricot.XML(response_xml).search(:ShippingRateTable).size
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
