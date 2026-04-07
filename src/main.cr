require "./checker.cr"
require "./web.cr"
require "./status.cr"

status = Status.new

web = Web.new(status)
web.start

checker = Checker.new(status)
checker.run
