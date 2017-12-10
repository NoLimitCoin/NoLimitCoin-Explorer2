# First point of contact for all peers requests to the application
# Author:: Sambhav Sharma
class PeersController < ApplicationController

  # Actions
  before_action :set_stats, only: [:index]

  # Renders the index page for Peers
  #
  # Author:: Sambhav Sharma
  # Date:: 09/12/2017
  # Reviewed By::
  #
  def index
    @peers = Peer.all.paginate(page: params[:page], per_page: params[:per_page] || GlobalConstant::DEFAULT_PER_PAGE)
    @peers_by_country = Peer.group(:country).count

    respond_to do |format|
      format.json do
        render json: @peers, status: 200
      end

      format.html
    end
  end
end
