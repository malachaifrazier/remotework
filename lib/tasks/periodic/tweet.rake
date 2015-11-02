namespace :periodic do
  desc "Tweets one job"
  task :tweet => :environment do
    job = Job.next_up_for_tweet.limit(1).first
    job.update_column(:last_tweeted_at, Time.zone.now)
    TweetService.new(job).tweet
  end
end
