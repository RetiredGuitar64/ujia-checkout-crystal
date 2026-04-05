require "http/client"
require "json"
require "log"
require "./create_student.cr"
require "./accounts.cr"

# 到了这个剩余秒数，就要开始签到
DEADLINE = 20

class Signer
  def initialize()
    # 提前初始化学生列表, 提高开始签到后的速度
    @students = [] of Student  # 每一个学生对象都存在这个数组里

    # 初始化学生列表
    ACCOUNTS.each do |account|
      student = Student.new(account)
      @students << student
    end
  end

  def run(courseSignInId : String, codeDistance : String)
    # 判断为普通签到还是密码签到
    if codeDistance == "200"

      # 普通签到，"200",
      # 则签到url为空
      codeStringUrl = nil
      # 直接进行签到post
      sleep 1
      @students.each do |student|
        student.post(courseSignInId, codeStringUrl)
      end
    else

      # 密码签到
      # codeDistance 不为200

      # 拼接url和密码
      codeStringUrl = "&codeDistance=" + codeDistance

      # 默认第一个为默认学生
      default_stu = @students[0]

      # 开始循环get剩余时间
      begin
        loop do
          # 获取剩余时间
          remaining_seconds = default_stu.get_remaining_seconds(courseSignInId, codeStringUrl)
          Log.info{"密码签到剩余 #{remaining_seconds} 秒"}

          # 小于指定时间，开始签到
          if remaining_seconds <= DEADLINE
            @students.each do |student|
              student.post(courseSignInId, codeStringUrl)
            end
            #签完到，退出
            break
          end

          # 一秒拉取一回剩余时间
          sleep 1
        end

      # 确保完成签到
      ensure
        Log.info{"二次签到开始"}
        @students.each do |student|
          student.post(courseSignInId, codeStringUrl)
        end
        Log.info{"二次签到完成"}
      end

    end
    Log.info{"本次签到完毕"}
    Log.info{"轮询重新开始..."}
    Log.info{"------------------------------"}
  end
end
