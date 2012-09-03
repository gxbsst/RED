class ERP::ContactPerson < ActiveRecord::Base
  include ERPSupport
  
  # Association
    belongs_to :customer, :foreign_key => "erp_customer_id"
    has_one :address, :foreign_key => "erp_contact_person_id"
  
  # Validation
    validates_uniqueness_of :email, :scope => :erp_customer_id
    validates_presence_of :first_name, :last_name, :email
  
  # A new StoreUser account should be created before creating
  #   contact person under the customer account in order to
  #   access to the customer services (MyAccount, etc.)
  def before_create
    self.name = "#{first_name} #{last_name}"
    store_user = StoreUser.find_by_email_address(self.email)
    store_user = create_store_user! if store_user.nil?
  end
  
  def before_destroy
    @original_email = self.email
    self.email = ""
  end
  
  # Rebuild accessibilities to customer's account (remove this contact from list)
  def after_destroy
    self.customer.rebuild_accessibilities(
      self.customer.contact_people.collect{|p| p.email} - [self.email]
    )
  end
  
  # Check up contact's email address in store users.
  # if exists and user's erp account number keeps blank, bind it with
  #     current customer account, else append an error message.
  def validate_on_create
    store_user = StoreUser.find_by_email_address( self.email )
    if store_user
      if store_user.erp_account_number.blank?
        store_user.update_attribute( "erp_account_number", self.customer.account_num )
      elsif store_user.erp_account_number != self.customer.account_num
        errors.add "email", "This email address has been assigned to another account."
      end
    end
  end
  
  private
    
    # Generate a new StoreUser and bind it as the contact person under current customer
    #   account.
    # NOTES:
    #   Initialized password are encrypted so a "Reset Password" email should be delivered
    #     after creating.
    def create_store_user!
      user = StoreUser.create!(
        :email_address => self.email,
        :erp_account_number => customer.account_num,
        :name => self.name,
        :company => customer.name,
        :password => StoreUser.encrypt_password("Generate password at #{Time.now.to_s}"),
        :security_token => StoreUser.generate_security_token,
        :creation_email => false
      )
      
      # Sending Mail: Reset Password
      StoreUserNotify.deliver_auto_generated(
        user,
        "http://www.red.com/reset_pwd/#{user.security_token}"
        # url_for(
        #   :controller => '/account',
        #   :action => 'reset_password',
        #   :token => user.security_token,
        #   :host => 'www.red.com'
        # )
      )
      user.update_attribute(:creation_email, true)
      
      return user
    end
    
end