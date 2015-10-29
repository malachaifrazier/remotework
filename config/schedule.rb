# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every :hour do
  rake "periodic:fetch_all_jobs"
end

every 51.minutes do
  rake "periodic:tweet"
end

every 1.day, at: '11:40 am' do
  rake "periodic:daily_alerts"
end

every :tuesday, at: '12:10pm' do
  rake "periodic:weekly_alerts"
end

# Learn more: http://github.com/javan/whenever
