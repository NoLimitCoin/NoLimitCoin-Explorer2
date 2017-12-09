# Basically for Header search
# Author:: Sambhav Sharma
class HeaderController < ApplicationController

  # Allows searching of blocks/transactions/addresses from header search bar
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def search
    if Block.where(block_hash: params["search-text"]).count > 0
      redirect_to controller: 'blocks', action: 'show', block_hash: params["search-text"]

    elsif Transaction.where(tx_hash: params["search-text"]).count > 0
      redirect_to controller: 'transactions', action: 'show', tx_hash: params["search-text"]

    elsif Address.where(address: params["search-text"]).count > 0
      redirect_to controller: 'addresses', action: 'show', address: params["search-text"]

    else
      redirect_to '/'
    end
  end
end
