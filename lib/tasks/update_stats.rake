namespace :stats do

  desc "Updates peers connected to the node"
  task update: :environment do
    puts "Fetching stats."
    stake_stats = RpcService.make_rpc('getstakinginfo')
    coin_stats = RpcService.make_rpc('getinfo')

    begin

    # Updating stats every 5 minute
    last_stat = Stat.last
    if (DateTime.current.to_i - (last_stat.try(:created_at).try(:to_i) || 0)) >= 300
      puts "Updating stats."
      Stat.create!({
         supply: coin_stats["moneysupply"],
         pos_difficulty: coin_stats["difficulty"]["proof-of-stake"],
         blocks: coin_stats["blocks"],
         net_stake_weight: stake_stats["Net Stake Weight"]
      })
    end

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
end
