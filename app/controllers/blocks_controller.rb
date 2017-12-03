# First point of contact for all block requests to the application
# Author:: Sambhav Sharma
class BlocksController < ApplicationController

  # Renders the index page for Blocks
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def index
    @blocks = Block.includes(transactions: :outputs).all.order(block_index: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page] || GlobalConstant::DEFAULT_PER_PAGE)
    @cmc_data = CmcService.get_ticker_data.first
    @stats = Stat.last

    respond_to do |format|
      format.json do
        render json: @blocks, status: 200
      end

      format.html
    end
  end
end
