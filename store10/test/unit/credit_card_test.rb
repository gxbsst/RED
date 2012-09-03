require File.dirname(__FILE__) + '/../test_helper'

class CreditCardTest < Test::Unit::TestCase

  def test_should_validate_creditcard_expired_date
    # Expiration Year or Month is blank
    assert_not_nil CreditCard.date_expired_validate("", "10")
    assert_not_nil CreditCard.date_expired_validate("10", "")
    
    # Expiration Year or Month isn't Numeric
    assert_not_nil CreditCard.date_expired_validate("test", "10")
    assert_not_nil CreditCard.date_expired_validate("10", "test")
    
    # Expiration Month range between 1 and 12
    assert_not_nil CreditCard.date_expired_validate("10", "0")
    assert_not_nil CreditCard.date_expired_validate("10", "13")

    # Expiration date equal or less current date
    assert_not_nil CreditCard.date_expired_validate(Time.now.months_ago(1).strftime("%y"), Time.now.months_ago(1).strftime("%m"))
    assert_not_nil CreditCard.date_expired_validate(Time.now.strftime("%y"), Time.now.strftime("%m"))
    
    # Expiration date more than current date
    assert_nil CreditCard.date_expired_validate(Time.now.next_month.strftime("%y"), Time.now.next_month.strftime("%y"))
  end
  
  def test_credit_card_number_luhn_check
    assert CreditCard.creditcard_luhn_validation?("5555555555554444")
    assert !CreditCard.creditcard_luhn_validation?("5555555555555555")
  end
  
  def test_credit_card_type_calc
    assert_equal "visa", CreditCard.creditcard_type("4111111111111111")
    assert_equal "mastercard", CreditCard.creditcard_type("5555555555554444")
    assert_equal "american_express", CreditCard.creditcard_type("378282246310005")
    assert_equal "discover", CreditCard.creditcard_type("6011111111111117")
  end
  
end
