# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :environment, @environment

set :output, "log/#{ @environment }_cron.log"

# updating peers every hour
every 1.hour do
  rake "peers:update"
end

# updating blocks every 5 minutes
every 5.minute do
  rake "blocks:update"
end

# updating stats every 5 minutes
every 5.minute do
  rake "stats:update"
end