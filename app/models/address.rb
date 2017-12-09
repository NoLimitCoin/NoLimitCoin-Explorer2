class Address < ActiveRecord::Base

  has_many :transaction_outputs
  has_many :output_transactions, through: :transaction_outputs

  has_many :transaction_inputs
  has_many :input_transactions, through: :transaction_inputs

  def coin_percentage
    (balance/Stat.last.supply) * 100
  end
end
