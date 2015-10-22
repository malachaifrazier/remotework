class TweetJob < ActiveJob::Base
  queue_as :low

  def perform
    job = Job.next_up_for_tweet.limit(1).first
    TweetService.new(job).tweet
    job.touch(:last_tweeted_at)
  end
end
