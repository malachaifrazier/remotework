namespace :periodic do
  desc "E-mails the weekly job alert digests"
  task :weekly_alerts => :environment do
    SendAlertsJob.new.perform_later('weekly')
  end
end
