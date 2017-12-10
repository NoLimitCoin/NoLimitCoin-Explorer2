# All cached data here!
# Author: Sambhav Sharma
class CachedData
  class << self

    # Gets and loads wealth distribution in memory
    #
    # Author:: Sambhav Sharma
    # Date:: 10/12/2017
    # Reviewed By::
    #
    def wealth_distribution
      Memcache.fetch("wealth_distribution", 5.minute.to_i) do
        coin_supply = Stat.last.supply

        top_10_holdings = Address.order(balance: :desc).limit(10).pluck(:balance).inject(:+)
        top_50_holdings = Address.order(balance: :desc).limit(50).pluck(:balance).inject(:+)
        top_100_holdings = Address.order(balance: :desc).limit(100).pluck(:balance).inject(:+)

        {
            "top_10": {
                holdings: top_10_holdings,
                percentage:  (top_10_holdings/coin_supply) * 100
            },
            "top_50": {
                holdings: top_50_holdings,
                percentage:  (top_50_holdings/coin_supply) * 100
            },
            "top_100": {
                holdings: top_100_holdings,
                percentage:  (top_100_holdings/coin_supply) * 100
            }
        }
      end
    end

    # Gets and loads wealth distribution graph data in memory
    #
    # Author:: Sambhav Sharma
    # Date:: 10/12/2017
    # Reviewed By::
    #
    def wealth_distribution_graph
      Memcache.fetch("wealth_distribution_graph", 5.minute.to_i) do
        coin_supply = Stat.last.supply

        top_10_holdings = Address.order(balance: :desc).limit(10).pluck(:balance).inject(:+).to_i
        top_50_holdings = Address.order(balance: :desc).offset(10).limit(40).pluck(:balance).inject(:+).to_i
        top_100_holdings = Address.order(balance: :desc).offset(50).limit(50).pluck(:balance).inject(:+).to_i
        others_holdings = (coin_supply - (top_10_holdings + top_50_holdings + top_100_holdings)).to_i

        {
            "top_10": top_10_holdings,
            "top_10_to_50": top_50_holdings,
            "top_50_to_100": top_100_holdings,
            "others": others_holdings
        }
      end
    end

    # Gets and loads last stat in memory
    #
    # Author:: Sambhav Sharma
    # Date:: 10/12/2017
    # Reviewed By::
    #
    def stat
      Memcache.fetch("stat", 5.minute.to_i) do
        Stat.last
      end
    end
  end
end