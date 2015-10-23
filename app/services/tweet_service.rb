class TweetService
  def initialize(job)
    @job = job
  end

  def tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key =        ENV["RA_TWITTER_CONSUMER_KEY"]
      config.consumer_secret =     ENV["RA_TWITTER_CONSUMER_SECRET"]
      config.access_token =        ENV["RA_TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["RA_TWITTER_ACCESS_TOKEN_SECRET"]
    end
    client.update job_description
  end

  private

  def job_description
    # Someday: Link shortening, hashtags. Today: lameness.
    link = Rails.application.routes.url_helpers.job_url(@job, host: 'http://www.remotelyawesomejobs.com')
    "#{@job.company}: #{@job.title}".truncate(135 - link.length) + " #{link}"
  end
end
