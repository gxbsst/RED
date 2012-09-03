class EncryptedAllOldCustomer < ActiveRecord::Migration
  def self.up
    require 'erp/encrypt'
    ErpOrder.find(:all, :conditions => 'erp_complete = 0').each do |order|
      unless order.order_user.order_account.payment_type == 1
        account = order.order_user.order_account
        account.update_attribute_with_validation_skipping(:encrypted_cc_number, Encrypt.rsa_encrypt(account.attributes['cc_number']))
        account.update_attribute_with_validation_skipping(:expiration_month, 10) if account.expiration_month.blank?
        account.update_attribute_with_validation_skipping(:expiration_year, 10) if account.expiration_year.blank?
        account.update_attribute_with_validation_skipping(:cardholder_name, 'Test User') if account.cardholder_name.blank?
        account.update_attribute_with_validation_skipping(:pfp_pnref, 'V78F0B8AA4D9') if account.pfp_pnref.blank?
        account.update_attribute_with_validation_skipping(:pfp_authcode, '010101') if account.pfp_authcode.blank?
        account.update_attribute_with_validation_skipping(:pfp_amount, '500') if account.pfp_amount.blank?
      end
      #============================================
      # Make order complete
      #============================================
      order.update_attributes(:erp_complete => true)

    end

    execute "DROP VIEW IF EXISTS `view_order_header`"

    #========================================================
    # Erase all exist creditcard number
    #========================================================
    #OrderAccount.find(:all).each {|account| account.update_attribute(:cc_number, '') }
    remove_column :order_accounts,    :cc_number
    
    add_column    :order_accounts,    :created_on, :datetime
    add_column    :order_accounts,    :updated_on, :datetime

    Country.find(3).update_attribute(:name, 'United Kingdom')
    Country.find(264).update_attribute(:fedex_code, 'GB')

    # ===========================================
    # Fix StoreUser ship_to_address.is_shipping bug
    # ===========================================
    #StoreUser.find(:all).each do |store_user|
    #  unless store_user.ship_to_address.nil?
    #    if store_user.ship_to_address.is_shipping == false
    #      store_user.ship_to_address.update_attribute(:is_shipping, true)
    #    end
    #  end
    #end

  end

  def self.down
    add_column    :order_accounts,    :cc_number,  :string, :limit => 17, :default => '4012888888881881'
    remove_column :order_accounts,    :created_on
    remove_column :order_accounts,    :updated_on

    execute "CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_order_header` AS select `ou`.`name` AS `name`,`ou`.`company` AS `company`,`ou`.`email_address` AS `email_address`,`o`.`order_number` AS `order_number`,`o`.`created_on` AS `created_on`,concat(left(`acct`.`cc_number`,2),_latin1'*******',right(`acct`.`cc_number`,4)) AS `cc_viaklix`,`acct`.`cc_number` AS `cc_number`,sum((`li`.`unit_price` * `li`.`quantity`)) AS `subtotal`,`o`.`order_status_code_id` AS `status_code`,`status`.`name` AS `status` from ((((`orders` `o` join `order_line_items` `li`) join `order_users` `ou`) join `order_status_codes` `status`) join `order_accounts` `acct`) where ((`o`.`id` = `li`.`order_id`) and (`o`.`order_user_id` = `ou`.`id`) and (`o`.`order_status_code_id` = `status`.`id`) and (`o`.`order_user_id` = `acct`.`order_user_id`)) group by `o`.`order_number`"
  end
end
