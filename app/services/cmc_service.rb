# Author: Sambhav Sharma
class CmcService
  class << self

    # Gets ticker data from Coin Market Cap
    #
    # Author:: Sambhav Sharma
    # Date:: 04/12/2017
    # Reviewed By::
    #
    def get_ticker_data
      uri = GlobalConstant::CMC_URL + GlobalConstant::CMC_TICKER + '/'
      connection = HttpService::Connection.new(uri)
      connection.get_json
    end
  end
end
