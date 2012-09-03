class OrderTransaction < ActiveRecord::Base
  belongs_to :order

  def viaklix_transaction
    ViaklixTransaction.find_by_transactionid(transaction_id)
  end
end
