require 'digest'

# Fake customer model for creating association to store user.
class FakeCustomer < ERP::Customer
  set_table_name "erp_customers"
  set_primary_key "account_num" 
end

class StoreUser < ActiveRecord::Base
  validates_presence_of   :name,          :message => ERROR_EMPTY
  validates_presence_of   :email_address, :message => ERROR_EMPTY
  validates_presence_of   :password,      :message => ERROR_EMPTY
  validates_confirmation_of :password
  validates_uniqueness_of :email_address, :message => 'You already have an account.<br>Please log in to your existing account'
  validates_length_of     :email_address, :maximum => 255
  validates_format_of     :email_address, :with => /^([^@\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})(\.?)$/, :message => "Please enter a valid email address."

  belongs_to :ship_to_address, :class_name => 'OrderAddress', :foreign_key => 'ship_to_address_id'
  belongs_to :bill_to_address, :class_name => 'OrderAddress', :foreign_key => 'bill_to_address_id'
  belongs_to :order_account
  
  belongs_to :customer, :class_name => "FakeCustomer", :foreign_key => "erp_account_number"
  
  attr_accessor :confirm_email, :confirm_password, :is_newly_created, :remote_ip, :remote_location, :user_agent, :request_path

  # If user is alreasy existed, return it.
  # Otherwise, try to create a new user with an encrypted password.
  # In this case, the encrypted password will NOT be sent to the end user,
  #   so he or she MUST reset the password via a link in the confirmation email.
  # NOTE:
  #   Send the confirmation email in WebAccountController
  def self.check_or_create_user(attributes, raw_input)
    
    # Loggin the start of this conversation
    log = ErpLog::AxStoreUserLog.start(attributes, raw_input)
    
    # Begin transcation
    begin
      user = find_by_email_address(attributes[:email_address])
      
      unless user.nil?
        
        original_attributes = user.attributes.dup
        
        # If the entered email address belongs to an exists user, check the ERP Account Number.
        # Update the ERP Account Number with the given value if the original value is EMPTY.
        # Otherwise, create an error message on this field.
        
        user.name = attributes[:name] unless user.name == attributes[:name]
  
        if user.erp_account_number.blank?
          user.erp_account_number = attributes[:erp_account_number] unless attributes[:erp_account_number].blank?
        elsif attributes[:erp_account_number] != user.erp_account_number
          user.errors.add :erp_account_number, "ERP Account Number is incorrect, the original value is '#{user.erp_account_number}'"
        end
        
        if user.errors.empty?
          unless user.attributes === original_attributes
            user.save
            log.return 'UPDATE', '0', user.attributes.to_yaml
          else
            log.return 'NO CHANGE', '0'
          end
        else
          log.return 'ERROR',
            user.errors.collect{ |attr, msg| msg }.join("\n"),
            user.errors.collect{ |attr, msg| "#{attr.upcase}:\n\t#{msg}" }.join("\n")
        end
  
        return user
  
      else
  
        # This email address is NOT be used.
        # Create an new record for this user with an encrypted password, and send an confirmation email to
        #   user to reset the password.
        user = new attributes.merge( 
          :password => encrypt_password("Generate password at #{Time.now.to_s}"),
          :security_token => generate_security_token
        )
        if user.valid? && is_domain_valid?(user.email_address.split('@').last)
          log.return 'CREATE', '0'
          user.save
          user.is_newly_created = true
        else
          log.return 'ERROR', "Email:\n\tEmail Server is invalid."
          user.errors.add :email_address, 'Email server is invalid.'
        end
  
        return user
  
      end
    rescue => e
      # Exception occured, log it in AxStoreUserLog
      log.exception e
      raise e
    end
  end

  def update_security_token
    update_attribute :security_token, self.class.generate_security_token
  end

  def self.encrypt_password(password)
    Digest::SHA1.hexdigest("Encrype password '#{password}'")
  end

  def self.generate_security_token
    Digest::SHA1.hexdigest("Generate security token at #{Time.now.to_s}")
  end
  
  # detect store user has already receive redone body.
  def has_already_received_redone?
    return self.customer && self.customer.red_one_shipped?
  end
  
  # Update user's password
  # Note:
  #   Correct original password is required for security reason.
  def change_password(original_password, params={})
    
    # Validating original password is correct or not
    unless original_password == self.password
      errors.add_to_base "Given original password is incorrect!"
      return false
    end
    
    # Updating password
    return update_attributes(params)
  end
  
  def my_account_log(erp_object,description)
    MyAccountLog.web_user_log(self,erp_object,description)
  end
  
  # Alias to self.email_address
  def email
    return self.email_address
  end
  
  private

  # Test the domain is valid or not.
  def self.is_domain_valid?(domain)
    result = `dig #{domain}`
    if result =~ /status: (\w+),/ && $1 == 'NOERROR'
      return true
    end
    return false
  end

  def self.ax_log(status, params)
    ErpLog::AxStoreUserLog.create(
      :name => params[:name],
      :email_address => params[:email_address],
      :status => status
    )
  end

end
