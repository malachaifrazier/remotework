class Job::Authentic < Job
  CATEGORIES = { '2' => Category.web, '3' => Category.design, '4' => Category.web, '5' => Category.mobile, '6' => Category.management }

  def self.feed_urls
    CATEGORIES.keys.map { |cat| "http://www.authenticjobs.com/rss/custom.php?terms=&type=1,2,3,4,5,6,7&cats=#{cat}&onlyremote=1&location=" }
  end

  def self.skip_description_scrape?
    true
  end

  def self.factory(entry)
    company, title = entry.title.split(': ')
    location = entry.summary.match(/.*?<strong>\((.*?)\)<\/strong>/)[1]
    category = '2'   # TODO
    Job.new(title: title,
            posted: entry.published,
            company: company,
            category: CATEGORIES[category],
            location: location,
            description: entry.summary,
            company_url: '',
            original_post_url: entry.entry_id.gsub(/^http:/, 'https:'),
            source: "Authentic Jobs")
  end
end
