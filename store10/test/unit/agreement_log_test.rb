require File.dirname(__FILE__) + '/../test_helper'

class AgreementLogTest < Test::Unit::TestCase

  def test_create_empty_agreement_log
    assert AgreementLog.create
  end
  
  def test_auto_write_store_user_detail
    assert store_user = StoreUser.create(:name => "test name", :password => "test password", :email_address => "test@test.com")
    assert agreement_log = AgreementLog.create(:store_user => store_user)
    assert agreement_log.store_user_id
    assert agreement_log.email_address
    assert agreement_log.name
  end
  
  def test_auto_write_ip_location
    assert agreement_log = AgreementLog.create(:remote_ip => "58.247.210.234")
    assert agreement_log.remote_location
  end

  def test_auto_write_order_detail
    assert order = Order.create(:order_number => Order.generate_order_number)
    assert agreement_log = AgreementLog.create(:order => order)
    assert agreement_log.order_number
  end

  def test_auto_write_agreement_detial
    Agreement.create(:name => "test").agreement_versions << agreement_version = AgreementVersion.new(:content => "test")
    assert agreement_log = AgreementLog.create(:agreement => agreement_version)
    assert agreement_log.agreement_version_id
    assert agreement_log.agreement_name
    assert agreement_log.agreement_version
  end

  def test_auto_write_download_detail
    DownloadCategory.create(:title => 'test', :code => 'test').downloads << download_version = Download.new(:mac => true, :version_revision => 1, :version_major => 1, :version_minor => 1)
    assert agreement_log = AgreementLog.create(:download => download_version)
    assert agreement_log.download_id
    assert agreement_log.download_name
    assert agreement_log.download_version
  end

end
