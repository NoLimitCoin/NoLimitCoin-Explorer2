class TransactionOutput < ActiveRecord::Base

  # Associations
  belongs_to :output_address, class_name: "Address", :foreign_key => 'address_id', optional: true
  belongs_to :output_transaction, class_name: "Transaction", :foreign_key => 'transaction_id'
end
