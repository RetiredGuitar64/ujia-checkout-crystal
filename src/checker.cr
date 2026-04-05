require "./accounts.cr"
require "http/client"
require "json"

class Checker
  getter name, token

  def initialize(@name : String = ACCOUNTS[0][0], @token : String = ACCOUNTS[0][1])
  end

  def run
    url = "https://www.eduplus.net/api/course/courses/v1/study?types=Theory,Train"
    cookie = "SESSION=#{@token}"

    headers = HTTP::Headers{
      "accept"         => "application/json, text/plain, */*",
      "x-access-token" => @token,
      "cookie"         => cookie,
      "user-agent"     => "okhttp/4.12.0",
      "host"           => "www.eduplus.net",
      "connection"     => "Keep-Alive",
    }

    response = HTTP::Client.get(url, headers)
    puts response.status_code
    json = JSON.parse(response.body)
    pp json["data"]
  end
end
