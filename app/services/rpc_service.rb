class RpcService

  # Makes RPC call to the wallet
  #
  # Author:: Sambhav Sharma
  # Date:: 20/11/2017
  #
  # Params:
  # +method+:: rpc method to be called
  # +args+:: arguments to be sent with the method
  #
  def self.make_rpc(method, args=[])
    url = "http://#{GlobalConstant::RPC_USERNAME}:#{GlobalConstant::RPC_PASSWORD}@#{GlobalConstant::RPC_HOST}:"\
      "#{GlobalConstant::RPC_PORT}"
    post_body = { 'method' => method, 'params' => args, 'id' => 'jsonrpc' }
    connection = HttpService::Connection.new(url)
    resp = connection.post_json(post_body)
    raise Exception.new(resp['error']) if resp['error']
    resp['result']
  end
end