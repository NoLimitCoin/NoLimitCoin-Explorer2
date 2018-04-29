# First point of contact for all stats requests to the application
# Author:: Sambhav Sharma
class StatsController < ApplicationController

  # Actions
  before_action :set_stats, only: [:index, :getmoneysupply]

  # Renders the index page for Peers
  #
  # Author:: Sambhav Sharma
  # Date:: 12/12/2017
  # Reviewed By::
  #
  def index
    respond_to do |format|
      format.json do
        render json: @stats, status: 200
      end
    end
  end

  # Returns the coin supply
  #
  # Author:: Sambhav Sharma
  # Date:: 30/04/2018
  # Reviewed By::
  #
  def getmoneysupply
    render text: @stats.supply, status: 200
  end
end
