# First point of contact for all address requests to the application
# Author:: Sambhav Sharma
class AddressesController < ApplicationController

  # Actions
  before_action :set_stats, only: [:index, :show]

  # Renders the index page for Addresses
  #
  # Author:: Sambhav Sharma
  # Date:: 09/12/2017
  # Reviewed By::
  #
  def index
    @company_addresses = Address.where(is_locked_for_game: true).order(balance: :desc)
    @addresses = Address.where(is_locked_for_game: false).order(balance: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page] || GlobalConstant::DEFAULT_PER_PAGE)

    respond_to do |format|
      format.json do
        render json: @addresses, status: 200
      end

      format.html
    end
  end

  # Renders the show page for a address
  #
  # Author:: Sambhav Sharma
  # Date:: 04/12/2017
  # Reviewed By::
  #
  def show
    if params[:address].present?
      ad_query = { address: params[:address]}
    elsif params[:id].present?
      ad_query = {id: params[:id]}
    else
      ad_query = {}
    end

    @address = Address.includes(:input_transactions, :output_transactions).find_by(ad_query)
    @input_transactions = @address.input_transactions
                              .paginate(page: params[:it_page], per_page: params[:it_per_page] || GlobalConstant::DEFAULT_PER_PAGE)
    @output_transactions = @address.output_transactions
                              .paginate(page: params[:ot_page], per_page: params[:ot_per_page] || GlobalConstant::DEFAULT_PER_PAGE)

    respond_to do |format|
      format.json do
        render json: @address, status: 200
      end

      format.html
    end
  end
end
