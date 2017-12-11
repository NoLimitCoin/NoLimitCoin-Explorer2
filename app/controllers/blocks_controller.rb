# First point of contact for all block requests to the application
# Author:: Sambhav Sharma
class BlocksController < ApplicationController

  # Actions
  before_action :set_stats, only: [:index, :show]

  # Renders the index page for Blocks
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def index
    @blocks = Block.includes(transactions: :outputs).all.order(block_index: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page] || GlobalConstant::DEFAULT_PER_PAGE)

    respond_to do |format|
      format.json do
        render json: @blocks, status: 200
      end

      format.html
    end
  end

  # Renders the show page for a block
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def show
    if params[:block_hash].present?
      block_query = { block_hash: params[:block_hash]}
    elsif params[:block_index].present?
      block_query = {block_index: params[:block_index]}
    elsif params[:id].present?
      block_query = {id: params[:id]}
    else
      block_query = {}
    end

    @block = Block.includes(transactions: :outputs).find_by(block_query)

    respond_to do |format|
      format.json do
        render json: @block, status: 200
      end

      format.html
    end
  end
end
