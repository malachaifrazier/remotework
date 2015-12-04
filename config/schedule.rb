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

every :hour, at: 0 do
  rake "periodic:fetch_rss_jobs[Job::StackOverflow]" 
end

every :hour, at: 5 do
  rake "periodic:fetch_rss_jobs[Job::WfhIo]" 
end

every :hour, at: 10 do
  rake "periodic:fetch_rss_jobs[Job::Authentic]" 
end

every :hour, at: 15 do
  rake "periodic:fetch_rss_jobs[Job::OffsiteCareers]" 
end

every :hour, at: 20 do
  rake "periodic:fetch_rss_jobs[Job::WeWorkRemotely]" 
end

every :hour, at: 25 do
  rake "periodic:fetch_rss_jobs[Job::HackerNews]" 
end

every :hour, at: 30 do
  rake "periodic:fetch_rss_jobs[Job::Github]" 
end

every :hour, at: 40 do
  rake "periodic:fetch_rss_jobs[Job::Dribbble]" 
end

every :hour, at: 50 do
  rake "periodic:fetch_twitter_jobs[Job::Jobspresso]" 
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

every 6.hours do
  rake "periodic:find_404"
end

every 1.day, :at => '12:01 am' do
  rake "periodic:expire_jobs"
end

# Learn more: http://github.com/javan/whenever
