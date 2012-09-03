require File.dirname(__FILE__) + '/../../test_helper'

class RedoneSerialNumberTest < Test::Unit::TestCase
  
  def setup
    # construct test fixtures.
    @account1 = AxAccount.create(
      :ax_account_number => 'CU 0000001',
      :email             => 'test@test.com',
      :cust_first_name   => 'test_first_name',
      :cust_last_name    => 'test_last_name'
    )
    @account1.ax_orders.create(
      :ax_order_number   => 'SO 0100001',
      :ax_account_number => 'CU 0000001'
    )
    @account1.ax_orders.first.ax_order_line_items.create(
      :ax_order_number => 'SO 0100001',
      :item_id         => '101001',
      :sales_item_reservation_number => '001'
    )
  end

  def test_update_new_redone_serial_number
    assert_equal 0, RedoneSerialNumber.count
    RedoneSerialNumber.update_records
    assert_equal 1, RedoneSerialNumber.count
  end
  
  def skip_test_update_exist_redone_serial_number
    @account1.ax_orders.first.ax_order_line_items.create(
      :ax_order_number => 'SO 0100001',
      :item_id         => '101001',
      :sales_item_reservation_number => '002'
    )
    RedoneSerialNumber.update_records
    assert_equal 2, RedoneSerialNumber.count
  end
end
