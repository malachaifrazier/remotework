class Job::Authentic < Job
  CATEGORIES =
    { '1' => Category.other,
      '2' => Category.development,
      '3' => Category.design,
      '4' => Category.development,
      '5' => Category.development,
      '6' => Category.management,
      '7' => Category.design,
      '8' => Category.other,
      '9' => Category.other }

  class << self
    def feed_urls
      CATEGORIES.keys.map { |cat| "http://www.authenticjobs.com/rss/custom.php?terms=&type=1,2,3,4,5,6,7&cats=#{cat}&onlyremote=1&location=" }
    end

    def skip_description_scrape?
      true
    end

    def factory(entry, feed, opts={})
      company, title = entry.title.split(': ')
      location = entry.summary.match(/.*?<strong>\((.*?)\)<\/strong>/)[1]
      Job.new(title: title,
              posted_at: entry.published,
              company: company,
              category: determine_category(feed),
              location: location,
              description: entry.summary,
              company_url: '',
              original_post_url: entry.entry_id.gsub(/^http:/, 'https:'),
              source: "Authentic Jobs")
    end

    def determine_category(feed)
      CATEGORIES[feed.feed_url.match(/.*?cats=([0-9]).*/)[1]]
    end
  end
end
