require File.dirname(__FILE__) + '/../../test_helper'

class AxInventoryTest < Test::Unit::TestCase
  def setup
    @http = stub(:request => stub(:is_a? => true, :code => 200, :body => response_xml))
    @http.stubs(:use_ssl=)
    @http.stubs(:verify_mode=)

    @http_failure = stub(:request => stub(:is_a? => false, :code => 500, :body => request_failed_xml))
    @http_failure.stubs(:use_ssl=)
    @http_failure.stubs(:verify_mode=)
  end

  def test_generate_request_xml
    assert_not_nil AxInventory.request_xml
  end

  def test_fetch_inventories
    Net::HTTP.stubs(:new).returns(@http)
    
    assert_equal response_items_count, AxInventory.fetch_inventories.size
  end
  
  def test_varian_report_for_new_add_items
    Net::HTTP.stubs(:new).returns(@http)
    
    assert_equal response_items_count, AxInventory.inventories_variance[:new_items].size
  end
  
  def test_variance_report_for_removed_items
    Net::HTTP.stubs(:new).returns(@http)
    
    # items(item_id 'demo') is not exists in AX
    AxInventory.create(:item_id => 'demo')
    assert_equal 1, AxInventory.inventories_variance[:removed_items].size
  end
  
  def test_variance_report_for_changed_items
    Net::HTTP.stubs(:new).returns(@http)
    
    # change items in local
    AxInventory.create({
        :pct_deposit     => 20.0,           # original: 10.0
        :item_price      => 10.0,           # original: 17500.0
        :item_id         => "101001",
        :item_name       => "RedOne Body",  # original: Red One
        :model_group_id  => "Quar",
        :amt_deposit     => 1000.0,         # original: 1750.0
        :item_group_id   => "Camera-FG",
        :dim_group_id    => "WLS",
        :shipping_points => 15.0            # original: 12.6
      })
    
    assert_equal 1, AxInventory.inventories_variance[:changed_items].size
  end
  
  def test_function_of_compare_equal?
    original = AxInventory.new
    current  = AxInventory.new
    
    assert AxInventory.compare_equal?(original, current)
    
    current.pct_deposit = 20.0
    current.item_price  = 10.0
    current.item_name   = 'test'
    current.amt_deposit = 1000.0
    current.shipping_points = 15.0
    
    assert !AxInventory.compare_equal?(original, current)
  end
  
  def test_update_inventories
    Net::HTTP.stubs(:new).returns(@http)
    
    AxInventory.update_inventories
    assert_equal response_items_count, AxInventory.count
  end

  private

  def response_xml
    %(<?xml version='1.0' encoding='UTF-8'?>
<soap:Envelope xmlns:soap='http://www.w3.org/2003/05/soap-envelope' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'>
  <soap:Body>
    <findListInventoryResponse xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/Inventory'>
      <Inventory>
        <InventTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/Inventory'>
          <DimGroupId>WLS</DimGroupId>
          <ItemGroupId>Camera-FG</ItemGroupId>
          <ItemId>101001</ItemId>
          <ItemName>Red One</ItemName>
          <ItemPrice>17500.00</ItemPrice>
          <ModelGroupId>Quar</ModelGroupId>
          <PctDeposit>10.00</PctDeposit>
          <AmtDeposit>1750.00</PctDeposit>
          <ShippingPoints>12.60</ShippingPoints>
        </InventTable>
        <InventTable class='entity' xmlns='http://schemas.microsoft.com/dynamics/2006/02/documents/Inventory'>
          <DimGroupId>WL2</DimGroupId>
          <ItemGroupId>Camera-RM</ItemGroupId>
          <ItemId>101101</ItemId>
          <ItemName>Xilinx FPGA</ItemName>
          <ItemPrice>915.00</ItemPrice>
          <ModelGroupId>NONQ</ModelGroupId>
        </InventTable>
      </Inventory>
    </findListInventoryResponse>
  </soap:Body>
</soap:Envelope>)
  end

  def response_items_count
    Hpricot.XML(response_xml).search(:InventTable).size
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
