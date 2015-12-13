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
    long_link = Rails.application.routes.url_helpers.job_url(@job, host: 'http://www.remotelyawesomejobs.com')
    short_link = " http://raws.me/#{LinkShorteningService.new.short_url(long_link)}"
    "#{@job.company}: #{@job.title}".truncate(130 - short_link.length - hashtags.length) + short_link + ' ' + hashtags
  end

  def hashtags
    hashtags = ["#job", "#remote", top_tag].join(' ')
  end

  def top_tag
    # Ordered by priority. Hashtag first, job tag second. Choose one.
    [
     ['rails','ruby-on-rails'],
     ['wordpress','wordpress'],
     ['design','design'],
     ['qa','qa'],
     ['django','django'],
     ['php','php'],
     ['android','android'],
     ['scala','scala'],
     ['elixir','elixir'],
     ['golang','golang'],
     ['java','java'],
     ['ember','ember'],
     ['angular','angular'],
     ['node','node'],
     ['js','javascript'],
     ['iOS','ios'],
     ['ObjC','objective-c'],
     ['swift','swift'],
     ['CSharp','c#'],
     ['chef','chef'],
     ['puppet','puppet'],
     ['ansible','ansible']
    ].each do |tag|
      return '#' + tag.first if @job.tags.include? tag.last
    end
  end
end
