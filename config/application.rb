require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module NolimitcoinExplorer2
  class Application < Rails::Application

    config.autoload_paths += Dir[Rails.root.join('lib'), Rails.root.join('app')]
    config.eager_load_paths += Dir[Rails.root.join('lib')]
  end
end
