set :application, 'nlc2-explorer'
set :repo_url, 'git@github.com:NoLimitCoin/Nolimitcoin-Explorer2.git' # Edit this to match your repository
set :pty, true
set :linked_files, %w{config/database.yml config/secrets.yml config/constants.yml config/rpc_config.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5

# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true


namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:stop'
      invoke 'puma:start'
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end