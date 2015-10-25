namespace :periodic do
  desc "E-mails the weekly job alert digests"
  task :weekly_alerts => :environment do
    # Heroku doesn't offer a weekly cron job, don't do anything unless
    # it's Monday.
    SendAlertsJob.perform_later('weekly') if Time.zone.now.monday?
  end
end
