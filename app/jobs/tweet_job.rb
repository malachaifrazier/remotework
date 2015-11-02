class TweetJob < ActiveJob::Base
  queue_as :low

  def perform
    job = Job.next_up_for_tweet.limit(1).first
    # job.touch(:last_tweeted_at)  WTF, not working???
    # job.save!
    job.update_column(:last_tweeted_at, Time.zone.now)
    TweetService.new(job).tweet
  end
end
