class Job::GolangProjects < Job
  before_create :check_for_duplicates
  
  class << self
    def feed_urls
      ["http://golangprojects.com/remoterss.xml"]
    end

    def factory(entry, feed, opts={})
      title, company = entry.title.split('@')
      location = entry.summary.split('-').first
      if company && title && location
        job = self.new(title: title.strip,
                       posted_at: entry.published,
                       company: company.strip,
                       location: location.strip,
                       description: entry.summary,
                       company_url: '',
                       original_post_url: entry.url,
                       source: "golangprojects.com")
        category = 'Development'
        job.rebuild_tags!(category, 'golang')
        return job
      end
    end
  end

  def fetch_description!(url)
    super(url, %w[div p ul li b br strong h2 h3])
    post_date = self.description.match(/.*?\(Posted (.*?)\).*/)
    self.posted_at = Date.parse(post_date[1])
    text = self.description.match /.*?\(Posted .*?\)(.*)/m
    self.description = text[1]
  end

  # Need to run this here becauase we actually set the post date in
  # fetch description on these oddballs. :-/
  def check_for_duplicates
    return false if GolangProjects.probable_duplicate(self).exists?
  end
end
