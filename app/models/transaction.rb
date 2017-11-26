class Transaction < ActiveRecord::Base

  # Associations
  belongs_to :block

  has_many :inputs, class_name: 'TransactionInput'
  has_many :input_addresses, through: :inputs

  has_many :outputs, class_name: 'TransactionOutput'
  has_many :output_addresses, through: :outputs

  # Enumerations
  enum tx_type: {normal: 1, stake: 2, new_coins: 3}
end