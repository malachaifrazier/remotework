namespace :periodic do
  desc "Tweets one job"
  task :tweet => :environment do
    job = Job.next_up_for_tweet.limit(1).first
    TweetService.new(job).tweet
  end
end
