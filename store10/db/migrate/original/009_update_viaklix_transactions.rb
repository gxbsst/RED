class UpdateViaklixTransactions < ActiveRecord::Migration
	def self.up
		File.open("#{RAILS_ROOT}/db/migrate/009_update_viaklix_transactions.txt").readlines.each do | line |
			data = line.split(',')
			cc_number = data[5]
			auth_code = data[6]
			viaklix = ViaklixTransaction.find_by_approvalcode(auth_code)
			if viaklix
				unless OrderTransaction.find_by_transaction_id(viaklix.transactionid)
					order_account = OrderAccount.find_by_cc_number(cc_number)	
					if order_account
						order = Order.find_by_order_user_id(order_account.order_user_id)
						if order
							OrderTransaction.create :order_id => order.id, :transaction_id => viaklix.transactionid
						end
					end
				end
			end
		end


		ViaklixTransaction.find(:all).each do | viaklix |
			if viaklix.ssl_amount.abs > 10.0
				unless OrderTransaction.find_by_transaction_id(viaklix.transactionid)
					order_addresses = OrderAddress.find(:all, :conditions => ['order_user_id != 0 and is_shipping = false and address = ?', viaklix.ssl_avs_address])
					if order_addresses.size == 1
						orders = Order.find_all_by_order_user_id(order_addresses.first.order_user_id)
						if orders.size == 1
							OrderTransaction.create :order_id => orders.first.id, :transaction_id => viaklix.transactionid
						end
						
					end

				end
			end
			
		end
		
	end

	def self.down
	end
end
