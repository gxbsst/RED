class OrderAccount < ActiveRecord::Base
  # Associations
  has_one :order_account_type
  has_many :orders
  belongs_to :order_address
  belongs_to :order_user

  #==============================
  # Accessable attributes
  #==============================
  attr_accessor :cc_number
  attr_accessor :credit_ccv

  # Validation
  validates_presence_of :order_user_id, :order_address_id
  #validates_length_of   :cc_number, :within => 14..16, :too_short => 'CC Number too short', :too_long => 'CC Number too long', :allow_nil => false
  #validates_length_of :routing_number, :in => 0..9
  #validates_length_of :account_number, :maximum => 20
  # Make sure these are only numbers
  #validates_format_of :cc_number, :with => /^[\d]*$/, :message => ERROR_NUMBER

  validates_format_of :credit_ccv, :with => /^[\d]*$/, :message => ERROR_NUMBER
  #validates_format_of :routing_number, :with => /^[\d]*$/,
  #                    :message => ERROR_NUMBER
  #validates_numericality_of :expiration_month, :expiration_year

  CREDIT_CARD_PAYMENT_TYPE = 0
  WIRE_TRANSFER_PAYMENT_TYPE = 1

  # Make sure expiration date is ok.
  def validate
    #errors.add(:cc_number, "There appears to be a typo in your Credit Card number.<br/>Please re-enter your card number.<br/> If you continue to have trouble, please <a url='/contactus.htm'>Contact Us.</a>") unless cc_number.creditcard?
    today = DateTime.now
    #if (today.month > self.expiration_month && today.year >= self.expiration_year)
    #	errors.add(:expiration_month, 'Please enter a valid expiration date.')
    #end

    # Add errors for credit card accounts
    #if (credit_card_payment? && self.cc_number.blank?)
    #  errors.add(:cc_number, ERROR_EMPTY)
    #end
  end

  # List of months for dropdown in UI
  def self.months
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
  end

  # List of years for dropdown in UI
  def self.years
    start_year = Date.today.year
    years = Array.new
    10.times do
      years << start_year
      start_year += 1
    end
    return years
  end

  # Obfuscates personal information about this account
  # - CC number
  def clear_personal_information
    number = String.new(self.cc_number)
    # How many spaces to replace with X's
    spaces_to_pad = number.length-4
    # Cut string
    new_number = number[spaces_to_pad,number.length]
    # Pad with X's
    new_number = new_number.rjust(spaces_to_pad, 'X')
    self.cc_number = new_number
    self.save
    # Return number in case we need it
    return new_number
  end

  #########################################
  # Overwriting default cc_number accessors
  #########################################
  #def cc_number=(cc_number)
  #  write_attribute(:cc_number, cc_number.to_s.gsub(/[^\d]/, ""))
  #end

  #def ssl_card_number
  #  "XXXX-XXXX-XXXX-#{cc_number[-4,4]}"
  #end

  def credit_card_payment?
    payment_type == CREDIT_CARD_PAYMENT_TYPE || payment_type.nil?
  end

  def wire_transfer_payment?
    payment_type == OrderAccount::WIRE_TRANSFER_PAYMENT_TYPE
  end

end


#######################################
# Credit Card Validate
#######################################
module CreditCardValidate
  def creditcard_type
    number = self.to_s.gsub(/[^\d]/, "")

    return 'visa' if number =~ /^4\d{12}(\d{3})?$/
    return 'mastercard' if number =~ /^5[1-5]\d{14}$/
    return 'discover' if number =~ /^6011\d{12}$/
    return 'american_express' if number =~ /^3[47]\d{13}$/
    return 'diners_club' if number =~ /^3(0[0-5]|[68]\d)\d{11}$/
    return 'enroute' if number =~ /^2(014|149)\d{11}$/
    return 'jcb' if number =~ /^(3\d{4}|2131|1800)\d{11}$/
    return 'bankcard' if number =~ /^56(10\d\d|022[1-5])\d{10}$/
    return 'switch' if number =~ /^49(03(0[2-9]|3[5-9])|11(0[1-2]|7[4-9]|8[1-2])|36[0-9]{2})\d{10}(\d{2,3})?$/ || number =~ /^564182\d{10}(\d{2,3})?$/ || number =~ /^6(3(33[0-4][0-9])|759[0-9]{2})\d{10}(\d{2,3})?$/
    return 'solo' if number =~ /^6(3(34[5-9][0-9])|767[0-9]{2})\d{10}(\d{2,3})?$/
    return 'unknown'
  end

  def creditcard?(type = nil)
    number = self.to_s.gsub(/[^\d]/, "")
    return false if number.length < 14 && number.length > 16

    if type
      return false unless creditcard_type == type
    end

    sum = 0
    for i in 0..number.length
      weight = number[-1*(i+2), 1].to_i * (2 - (i%2))
      sum += (weight < 10) ? weight : weight - 9
    end

    return true if number[-1,1].to_i == (10 - sum%10)%10
    return false
  end
end

String.send :include, CreditCardValidate
Integer.send :include, CreditCardValidate
