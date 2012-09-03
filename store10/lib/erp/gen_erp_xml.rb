module GenErpXml
  def truncate_field(text, length = 24)
    if text.empty? then return '' end
    text.length > length ? text[0...length] : text
  end

  def gen_erp_account_xml(uuid)
    xml = ""
    doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
    doc.instruct!
    doc.soap12 :Envelope,
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
  "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
      doc.soap12 :Body do
        doc.createCustomers :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/Customers" do
          doc.DocumentContext do
            doc.MessageId( uuid ) 
            doc.SourceEndpointUser( AppConfig.SOAP_USER )
            doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
            doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
          end
          doc.Customers do
            doc.CustTable_1 :class => 'entity' do
              # Bill To Address Block / Customer Master Header
              doc.City bill_city
              doc.CountryRegionId bill_regionid
              doc.Currency AppConfig[:ERP_SALES_CURRENCY]
              doc.CustGroup AppConfig[:ERP_SALES_GROUP]
              doc.Email email
              doc.LanguageId AppConfig[:ERP_LANG_ID]
              # doc.Name is EITHER Company Name || First Name + Last Name
              doc.Name( truncate_field(company, 60) )
              doc.Phone( bill_telephone )
              doc.State( bill_state )
              # Address 1 plus a new line, plus Address 2
              doc.Street( truncate_field(bill_address, 740) )
              doc.ZipCode( bill_zip )
              doc.ContactPerson_1 :class => 'entity' do
                doc.Email( email )
                doc.FirstName( truncate_field(first_name) )
                doc.LastName( truncate_field(last_name) )
                doc.Name( truncate_field(company, 60) ) # First name + Last name
                doc.selectedAddress 'Home'
              end
              # Ship To Address Block
              doc.Address_1 :class => 'entity' do
                doc.City( ship_city )
                doc.CountryRegionId( ship_regionid )
                doc.State( ship_state )
                # Address 1 plus a new line, plus Address 2
                doc.Street( truncate_field(ship_address, 740) )
                doc.ZipCode( ship_zip )
              end
            end
          end
        end
      end
  end
    return xml
  end

  def gen_erp_order_xml(uuid)
    xml = ""
    doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
    doc.instruct!
    #doc.comment!( "ERP Customer Account : " + storeuser.erp_account_number.to_s )
    doc.soap12 :Envelope,
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
  "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
      doc.soap12 :Body do
        doc.createSalesOrder :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/SalesOrder" do
          doc.DocumentContext do
            doc.MessageId( uuid ) 
            doc.SourceEndpointUser( AppConfig.SOAP_USER )
            doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
            doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
          end
          doc.SalesOrder do
            doc.SalesTable :class => 'entity' do
              doc.CustAccount erp_account_number
              # Ship To Address Block
              doc.DeliveryCity ship_city
              doc.DeliveryCountryRegionId ship_regionid
              doc.DeliveryDate( Time.now.strftime('%Y-%m-%d') )
              doc.DeliveryState ship_state
              doc.DeliveryStreet truncate_field( ship_address, 740 )
              doc.DeliveryZipCode ship_zip
              if creditcard_payment?
                doc.PurchOrderFormNum( "WEB" + order_number.to_s )
              elsif wire_transfer_payment?
                doc.PurchOrderFormNum( "WIRE" + order_number.to_s )
              end
              # recalculate order_line_items for AX specification.
              erp_order_line_items.each do |item|
                doc.SalesLine :class => 'entity' do
                  doc.ItemId( item[:item_id] )
                  doc.SalesQty( item[:quantity] )
                  doc.SalesUnit( "Ea" )
                end
              end
              # Bill To Address Block
              doc.Address :class => 'entity' do
                doc.City bill_city
                doc.CountryRegionId bill_regionid
                doc.State bill_state
                doc.Street truncate_field(bill_address, 740)
                doc.ZipCode bill_zip
              end
            end
          end
        end
      end
  end
    return xml
  end

  def gen_erp_creditcard_xml(uuid)
    xml = ""
    doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
    doc.instruct!
    doc.soap12 :Envelope,
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
  "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
      doc.soap12 :Body do
        doc.createCreditCardWeb :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/CreditCardWeb" do
          doc.DocumentContext do
            doc.MessageId( uuid ) 
            doc.SourceEndpointUser( AppConfig.SOAP_USER )
            doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
            doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
          end
          doc.CreditCardWeb do
            doc.CreditCardWeb_1 :class => 'entity' do
              doc.AmountMST pfp_amount
              doc.AuthCode pfp_authcode
              doc.CardNum "\n" + encrypted_cc_number
              doc.CID 'xsi:nil' => 'true', 'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance" 
              doc.CustAccount erp_account_number
              doc.ExpDateMth expiration_month
              doc.ExpDateYr expiration_year
              #doc.NameOnCard(truncate_field(nameoncard, 60))
              doc.PNRef pfp_pnref
              doc.SalesId erp_order_number
            end
          end
        end
      end
  end
    return xml
  end

  def GenErpXml.gen_erp_exception_recid_xml(uuid, query_uuid)
    xml = ""
    doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
    doc.instruct!
    doc.soap12 :Envelope,
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
  "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
      doc.soap12 :Body do
        doc.findEntityKeyListSysExceptionTable :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/SysExceptionTable" do
          doc.DocumentContext do
            doc.MessageId( uuid ) 
            doc.SourceEndpointUser( AppConfig.SOAP_USER )
            doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
            doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
          end
          doc.QueryCriteria :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/QueryCriteria" do
            doc.CriteriaElement do
              doc.DataSourceName "SysExceptionTable_1"
              doc.FieldName "AifMessageId"
              doc.Operator "Equal"
              doc.Value1 "#{query_uuid}"
            end
          end
        end
      end
  end
    return xml
  end

  def GenErpXml.gen_erp_exception_result_xml(uuid, recid)
    xml = ""
    doc = Builder::XmlMarkup.new(:target => xml, :indent => 2)
    doc.instruct!
    doc.soap12 :Envelope,
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
  "xmlns:soap12" => "http://www.w3.org/2003/05/soap-envelope" do
      doc.soap12 :Body do
        doc.readSysExceptionTable :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/SysExceptionTable" do
          doc.DocumentContext do
            doc.MessageId( uuid ) 
            doc.SourceEndpointUser( AppConfig.SOAP_USER )
            doc.SourceEndpoint( AppConfig.SOAP_SOURCE_ENDPOINT )
            doc.DestinationEndpoint( AppConfig.SOAP_DEST_ENDPOINT )
          end
          doc.EntityKey :xmlns => "http://schemas.microsoft.com/dynamics/2006/02/documents/EntityKey" do
            doc.KeyData do
              doc.KeyField do
                doc.Field "RecId"
                doc.Value "#{recid}"
              end
            end
          end
        end
      end
  end
    return xml
  end

end

ErpOrder.send :include, GenErpXml
