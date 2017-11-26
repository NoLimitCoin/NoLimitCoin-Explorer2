# encoding: utf-8
module GlobalConstant

  # Load environment specific constants
  env_constants = YAML.load_file(Rails.root.to_s + '/config/constants.yml')
  rpc_config = YAML.load_file(Rails.root.to_s + '/config/rpc_config.yml')

  # RPC Settings
  RPC_USERNAME = rpc_config['username']
  RPC_PASSWORD = rpc_config['password']
  RPC_HOST = rpc_config['host']
  RPC_PORT = rpc_config['port']
end
