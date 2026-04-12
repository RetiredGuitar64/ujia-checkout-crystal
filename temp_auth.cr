require "./src/auth_saver.cr"

# 临时认证脚本，还不知道该怎么接入到主程序
auth = AuthSaver.new

puts "请输入手机号: "
phone : String = gets || ""

if phone.size != 11
  puts "手机号位数不正确！"
  exit(1)
end

puts "请输入密码："
password : String = gets || ""

print "\e[2J\e[H"
STDOUT.flush

puts "开始认证..."

token = auth.auth_with_password(phone, password)

sleep 1.seconds

Log.info{ "认证完毕：请自行将token加入账号文件" }
