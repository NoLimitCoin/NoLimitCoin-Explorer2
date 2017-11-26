class Block < ActiveRecord::Base

  # Associations
  has_many :transactions

end
