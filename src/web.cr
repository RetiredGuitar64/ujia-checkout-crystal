require "http/server"
require "log"

BIND_ADDRESS = "0.0.0.0"
BIND_PORT = 28888

class Web
  def initialize
  end

  def start
    web = HTTP::Server.new do |context|
      context.response.content_type = "text/plain"
      context.response.print("hello")
    end
    address = web.bind_tcp(BIND_ADDRESS, BIND_PORT)
    web.listen
  end
end

web = Web.new
web.start
