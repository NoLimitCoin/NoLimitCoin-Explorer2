class Transaction < ActiveRecord::Base

  # Associations
  belongs_to :block

  has_many :inputs, class_name: 'TransactionInput'
  has_many :input_addresses, through: :inputs

  has_many :outputs, class_name: 'TransactionOutput'
  has_many :output_addresses, through: :outputs

  # Enumerations
  enum tx_type: {normal: 1, stake: 2, new_coins: 3}


  # Calculates value out for each transaction by adding up total value out of each output
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def value_out
    outputs.collect(&:value).inject(&:+)
  end
end