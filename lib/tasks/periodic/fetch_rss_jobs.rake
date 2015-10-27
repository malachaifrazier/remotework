namespace :periodic do
  desc "Downloads new job posts"
  task :fetch_rss_jobs => :environment do
    # Keep StackOverflow at the end... we have a vast majority
    # of jobs sourced from them and if there are any duplicates
    # let's let the smaller sites "win."
    RssIngestionJob.perform_later([ENV['JOB_CLASS']])
  end
end
