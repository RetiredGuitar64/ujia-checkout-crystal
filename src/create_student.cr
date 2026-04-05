require "http/client"
require "json"
require "log"
require "./accounts.cr"

class Student
  @name : String
  @token : String
  @post_url : String

  def initialize(account : Hash)
    @name = account[:name]
    @token = account[:token]
    cookie = "SESSION=#{@token}"

    @post_url = ""
    @sign_in_headers = HTTP::Headers {
      "accept"         => "application/json, text/plain, */*",
      "x-access-token" => @token,
      "content-length" => "0",
      "cookie"         => cookie,
      "user-agent"     => "okhttp/4.12.0",
      "host"           => "www.eduplus.net",
      "connection"     => "Keep-Alive",
    }
  end

  def post(courseSignInId : String, codeStringUrl : (String | Nil))
    # 在开始签到后，马上拼接url
    @post_url = "https://www.eduplus.net/api/course/clock_in/study?signInId=#{courseSignInId}#{codeStringUrl}"
    response = HTTP::Client.post(@post_url, headers: @sign_in_headers)

    if response.status_code == 200
      Log.info{"#{@name} 签到成功"}
    else
      Log.info{"#{@name} 未签到成功！！请手动签到，未获取到签到码"} if codeStringUrl.nil?
      Log.info{"#{@name} 未签到成功！！请手动签到，签到码#{codeStringUrl.split('=')[1]}"} if !codeStringUrl.nil?
    end
  end
end


