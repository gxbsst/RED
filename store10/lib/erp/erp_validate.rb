module ErpValidate

  def is_blank?(field)
    if self.send(field.to_sym).blank?
      errors.add :id, "#{field} is blank."
    end
  end

  def erp_valid?
    # ===========================================
    # Billing_address Block
    # ===========================================
    if billing_address.nil?
      errors.add :id, "billing_addresses association is broken."
    else
      %w(bill_city bill_regionid first_name last_name bill_telephone bill_state bill_address bill_zip).each do |field|
        is_blank?(field)
      end
    end

    # ===========================================
    # Shipping_address Block
    # ===========================================
    if shipping_address.nil?
      errors.add :id, "shipping_addresses association is broken."
    else
      %w(ship_city ship_regionid ship_state ship_address ship_zip).each do |field|
        is_blank?(field)
      end
    end

    # ===========================================
    # Order_user Block
    # ===========================================
    if order_user.nil?
      errors.add :id, "order_user association is broken."
    else
      # =========================================
      # Order_account Block
      # =========================================
      if order_user.order_account.nil?
        errors.add :id, "order_user.order_account association is broken."
      else
        if creditcard_payment?
          %w(pfp_amount pfp_authcode pfp_pnref encrypted_cc_number expiration_year expiration_month nameoncard).each do |field|
            is_blank?(field)
          end
        end
      end
    end

    # ===========================================
    # Store_user Block
    # ===========================================
    if order_user.store_user.nil?
      errors.add :id, "order_user.store_user association is broken."
    else
      %w(email company).each do |field|
        is_blank?(field)
      end
    end

    # ===========================================
    # Order Block
    # ===========================================
    %w(order_number).each do |field|
      is_blank?(field)
    end

    # ===========================================
    # Order_line_items Block
    # ===========================================
    if order_line_items.empty?
      errors.add :id, "order.order_line_items is empty."
    else
      order_line_items.each do |item|
        if item.product.erp_product_item.blank?
          errors.add :id, 'item is blank.'
        end
        if item.quantity.blank?
          errors.add :id, 'item quantity is blank.'
        end
      end
    end

    errors.empty?
  end
end

ErpOrder.send :include, ErpValidate
