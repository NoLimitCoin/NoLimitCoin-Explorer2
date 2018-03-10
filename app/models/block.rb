class Block < ActiveRecord::Base

  # Associations
  has_many :transactions

  # Calculates value out for each block by adding up total value out of each transaction
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def value_out
    stake_value > 0 ? stake_value : transactions.collect(&:value_out).inject(&:+)
  end

  # Calculates total coins created as stake
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def stake_value
    transactions.collect(&:stake_value).inject(&:+)
  end
end
