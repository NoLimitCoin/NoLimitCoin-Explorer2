# Author:: Sambhav Sharma
class ApplicationController < ActionController::Base
  include ExceptionHelper

  protect_from_forgery with: :exception
  before_action :set_stats

  private
  # Sets stats of the coin in shared variables
  #
  # Author:: Sambhav Sharma
  # Date:: 2/06/2016
  #
  def set_stats
    @cmc_data = CmcService.get_ticker_data.try(:first)
    @stats = Stat.last
  end
end
