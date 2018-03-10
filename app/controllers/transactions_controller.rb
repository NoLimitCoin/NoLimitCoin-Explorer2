# First point of contact for all transaction requests to the application
# Author:: Sambhav Sharma
class TransactionsController < ApplicationController

  # Actions
  before_action :set_stats, only: [:index, :show]

  # Renders the index page for Transactions
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def index
    @transactions = Transaction.includes(:block, :input_addresses, :output_addresses).all.order(block_id: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page] || GlobalConstant::DEFAULT_PER_PAGE)

    respond_to do |format|
      format.json do
        render json: @transactions, status: 200
      end

      format.html
    end
  end

  # Renders the show page for a transaction
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def show
    if params[:tx_hash].present?
      tx_query = { tx_hash: params[:tx_hash]}
    elsif params[:id].present?
      tx_query = {id: params[:id]}
    else
      tx_query = {}
    end

    @tx = Transaction.includes(:block, inputs: [:input_address, :input_transaction], outputs: [:output_address]).find_by(tx_query)

    respond_to do |format|
      format.json do
        render json: @tx, status: 200
      end

      format.html
    end
  end
end
