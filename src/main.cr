require "./checker.cr"
require "./web.cr"
require "./status.cr"
require "./accounts_reader.cr"

# 读取账号
accounts_reader = AccountsReader.new
accounts = accounts_reader.read_accounts

# 空的话，直接退出
if accounts.empty?
  Log.fatal{"无可用账号，程序退出"}
  exit(1)
end

# 初始化web状态变量
status = Status.new

# 传入status,启动web
web = Web.new(status)
web.start

# 传入status和账号数组，启动轮询
checker = Checker.new(status, accounts)
checker.run
