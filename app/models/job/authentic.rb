class Job::Authentic < Job
  CATEGORIES =
    { '1' => 'other',
      '2' => 'development',
      '3' => 'design',
      '4' => 'development',
      '5' => 'development',
      '6' => 'management',
      '7' => 'design',
      '8' => 'other',
      '9' => 'other' }

  class << self
    def feed_urls
      CATEGORIES.keys.map { |cat| "http://www.authenticjobs.com/rss/custom.php?terms=&type=1,2,3,4,5,6,7&cats=#{cat}&onlyremote=1&location=" }
    end

  
    def factory(entry, feed, opts={})
      company, title = entry.title.split(': ')
      location = entry.summary.match(/.*?<strong>\((.*?)\)<\/strong>/)[1]
      job = self.new(title: title,
                     posted_at: entry.published,
                     company: company,
                     location: location,
                     description: entry.summary,
                     company_url: '',
                     original_post_url: entry.entry_id.gsub(/^http:/, 'https:'),
                     source: "Authentic Jobs")
      category = determine_category(feed)
      job.rebuild_tags!(category)
      return job
    end

    def determine_category(feed)
      CATEGORIES[feed.feed_url.match(/.*?cats=([0-9]).*/)[1]]
    end
  end

  def fetch_description!(url)
    rss_description = self.description
    parsed = rss_description.match(/<p>(.*?)<\/p>.*?<strong>\((.*?)\)<\/strong>.*/)
    self.description.gsub!(/.*?<strong>\((.*?)\)<\/strong>.*/, "<p>Job Type: <b>#{parsed[1]}</b><br/>Location: <b>#{parsed[2]}</b></p>")
  end  
end
