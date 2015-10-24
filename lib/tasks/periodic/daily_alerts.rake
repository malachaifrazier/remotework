namespace :periodic do
  desc "E-mails the daily job alert digests"
  task :daily_alerts => :environment do
    SendAlertsJob.new.perform_later('daily')
  end
end
