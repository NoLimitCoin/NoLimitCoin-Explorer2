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
      begin
        uri = GlobalConstant::CMC_URL + GlobalConstant::CMC_TICKER + '/'
        connection = HttpService::Connection.new(uri)
        connection.get_json
      rescue Exception => e
        Rails.logger.error e.message
        Rails.logger.error e.backtrace
      end
    end
  end
end
