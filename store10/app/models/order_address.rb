class OrderAddress < ActiveRecord::Base
  # Association
  has_one :order_account
  belongs_to :order_user
  belongs_to :country
  # Validation
  # validates_presence_of :order_user_id, :country_id
  # # validates_presence_of :zip, :message => "#{ERROR_EMPTY} If you live in a country that doesn't have postal codes please enter '00000'."
  # validates_presence_of :telephone, :message => ERROR_EMPTY
  # validates_presence_of :address, :message => ERROR_EMPTY
  # validates_length_of   :address, :maximum => 255 

  # Finds the shipping address for a given OrderUser
  def self.find_shipping_address_for_user(user)
    find(:first, :conditions => ["order_user_id = ? AND is_shipping = 1", user.id])
  end 
  def self.find_billing_address_for_user(user)
    find(:first, :conditions => ["order_user_id = ? AND is_shipping = 0", user.id])
  end 
  
  # return tax rate
  def tax_rate
    if country.fedex_code == 'US'
      case state
      when 'WA' : return 9.50
      when 'CA' : return 8.85
      end 
    end 
    return 0.0 
  end 
end
