class CreateOrderTransactions < ActiveRecord::Migration
	def self.up
		create_table :order_transactions do |t|
			t.column :created_on, :datetime
			t.column :order_id, :int
			t.column :transaction_id, :string
			t.column :description, :string
		end

		Order.find(:all).each do | order |
			if order.transaction_id && (order.transaction_id.size > 0)
				OrderTransaction.create :order_id => order.id, :transaction_id => order.transaction_id
			end
		end
		remove_column :orders, :transaction_id
		remove_column :orders, :authorization_code

		ViaklixTransaction.find(:all).each do | viaklix_transaction |
			unless OrderTransaction.find_by_transaction_id(viaklix_transaction.transactionid)
				order_transaction_created = false
				OrderAddress.find_all_by_address_and_zip(viaklix_transaction.ssl_avs_address, viaklix_transaction.ssl_avs_zip).each do | order_address |
					order_user = order_address.order_user
					if order_user
						if order_user.orders.size == 1
							OrderTransaction.create :order_id => order_user.orders.first.id, :transaction_id => viaklix_transaction.transactionid
							order_transaction_created = true
						else 
							order_user.orders.each do | order |
								if (order.total.abs == viaklix_transaction.ssl_amount.abs) || (0.1 * order.total.abs == viaklix_transaction.ssl_amount.abs)
									OrderTransaction.create :order_id => order.id, :transaction_id => viaklix_transaction.transactionid
									order_transaction_created = true
									break
								end
							end
						end
					end
					if order_transaction_created
						break
					end
				end
			end
		end

	end

	def self.down
		drop_table :order_transactions
		add_column    :orders, :transaction_id, :string 
		add_column    :orders, :authorization_code, :string 
	end
end
