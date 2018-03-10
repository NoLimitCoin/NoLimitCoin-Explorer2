namespace :peers do

  desc "Updates peers connected to the node"
  task update: :environment do
    peers = RpcService.make_rpc('getpeerinfo')

    begin

    Peer.transaction do
      peers_to_add = []

      peers.each do |peer|
        ip_addr, port = peer["addr"].split(':')
        puts "Adding peer: #{ip_addr}"

        location = Geokit::Geocoders::IpGeocoder.geocode(ip_addr)

        peer_data = {
            ip_address: ip_addr,
            port: port,
            services: peer["services"],
            last_send: peer["last_send"],
            last_recv: peer["last_recv"],
            conn_time: peer["conn_time"],
            version: peer["version"],
            sub_ver: peer["subver"],
            inbound: peer["inbound"],
            starting_height: peer["startingheight"],
            ban_score: peer["banscore"]
        }

        # Adding country information to peer if it was found
        if location.country_code != "XX"
          peer_data = peer_data.merge({
            country_code: location.country_code,
            country: location.country
          })
        end

        # Adding lat long information to peer, if it was found
        if location.success?
          peer_data = peer_data.merge({
            lat: location.lat,
            long: location.lng,
            city: location.city
          })
        end

        peers_to_add.push(peer_data)
      end
      Peer.delete_all
      Peer.create!(peers_to_add)
    end

    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end
end
