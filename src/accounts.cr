require "log"

class AccountsReader
  @accounts : Array({name: String, token: String})
  getter accounts : Array({name: String, token: String})

  def initialize
    @accounts = [] of {name: String, token: String}
  end

  def read_accounts(path : String = "./accounts.txt")
    @accounts.clear

    begin
      File.each_line(path) do |line|
        line = line.strip
        next if line.empty?
        if line.starts_with?("#")
          Log.info{"--------------------"}
          Log.info{"!! 跳过账号 !! #{line}"}
          next
        end
        parts = line.split("|",2)
        if parts.size != 2
          Log.warn{"!! 跳过格式错误行 !! #{line}"}
          next
        end
        name = parts[0].strip
        token = parts[1].strip
        if name.empty? || token.empty?
          Log.warn{"!! 跳过 name/token 为空的行 !! #{line}"}
          next
        end

        if token.size != 48
          Log.info{"--------------------"}
          Log.warn{"!! 警告！账号 #{name} 的token: #{token} 不符合48位长度！token可能缺失 !!"}
          Log.info{"--------------------"}
        end
        Log.info{"加载账号 #{name}, token: #{token}"}
        @accounts << {name: name, token: token}
      end
    rescue ex
      Log.error{"读取账号文件失败: #{ex.message}"}
    end

    Log.info{"--------------------"}
    Log.info{"账号加载完成:"}
    @accounts.each do |account|
      Log.info{"昵称: #{account[:name]}, token: #{account[:token]}"}
    end
    Log.info{"--------------------"}
    Log.info{"请确认账号是否缺失"}
    Log.info{"--------------------"}
  end
end

a = AccountsReader.new
a.read_accounts
