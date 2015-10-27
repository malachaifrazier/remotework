class TweetJob < ActiveJob::Base
  queue_as :low

  def perform
    ActiveRecord::Base.connection_pool.with_connection do
      job = Job.next_up_for_tweet.limit(1).first
      #  job.touch(:last_tweeted_at)  WTF, not working???
      job.last_tweeted_at = Time.zone.now
      job.save!
      TweetService.new(job).tweet
    end
  end
end
