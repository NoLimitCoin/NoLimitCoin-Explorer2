# First point of contact for all stats requests to the application
# Author:: Sambhav Sharma
class StatsController < ApplicationController

  # Actions
  before_action :set_stats, only: [:index]

  # Renders the index page for Peers
  #
  # Author:: Sambhav Sharma
  # Date:: 12/12/2017
  # Reviewed By::
  #
  def index
    @stats = Stat.last

    respond_to do |format|
      format.json do
        render json: @stats, status: 200
      end
    end
  end
end
