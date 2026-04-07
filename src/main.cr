require "./checker.cr"
require "./web.cr"
require "./status.cr"

status = Status.new

web = Web.new(status)
web.start

loop do
  sleep 5
  status.display_normal_status
  sleep 5
  status.display_404_status
  sleep 5
  status.display_signin_code("1234")
end

# checker = Checker.new(status)
# checker.run
