class CleanupDupes < ActiveRecord::Migration
	def self.up
		
		# fix up broken shipping/billing addresses
		Order.find(:all).each do | order |
			billing_address = order.billing_address
			shipping_address = order.shipping_address
			unless shipping_address
				shipping_address = billing_address.clone
				shipping_address.is_shipping = 1
				shipping_address.save
				next
			end

			unless billing_address
				billing_address = shipping_address.clone
				billing_address.is_shipping = 0
				billing_address.save
				next
			end
		end

		# Create new order_users if needed
		Order.find(:all).each do | order |
			if Order.find(:first, :conditions => ['order_user_id = ? and id != ?', order.order_user_id, order.id])
				billing_address = order.billing_address.clone
				shipping_address = order.shipping_address.clone
				order_account = order.account.clone
				order_user = order.order_user.clone
				order_user.save
				order.order_user = order_user
				order.save
				billing_address.order_user = order_user
				billing_address.save
				shipping_address.order_user = order_user
				shipping_address.save
				order_account.order_user = order_user
				order_account.save
			end
		end

		# Clear out order users with no orders
		OrderUser.find(:all).each do | order_user |
			if order_user.orders.size == 0
				order_user.destroy
			end
		end
		
		
		# Clear out dupes
		OrderUser.find(:all).each do | order_user |
			addresses = order_user.order_addresses.find_all_by_is_shipping(true)
			addresses.pop
			addresses.map { | address | address.destroy }
			addresses = order_user.order_addresses.find_all_by_is_shipping(false)
			addresses.pop
			addresses.map { | address | address.destroy }
			
			order_accounts = OrderAccount.find_all_by_order_user_id(order_user.id)
			order_accounts.pop
			order_accounts.map { | order_account | order_account.destroy }
		end
		
		
		
	end

	def self.down
	end
end
