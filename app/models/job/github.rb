class Job::Github < Job
  def self.feed_urls
    ["https://jobs.github.com/positions.atom"]
  end

  def self.factory(entry, feed, opts={})
    link = entry.links.first.gsub(/^http:/, 'https:')
    entry_title = entry.title.split(' at ')
    title = entry_title.shift
    company, location =  entry_title.join(' ').split(' in ')

    # GitHub lies about its posting date and puts them in the future
    # sometimes. =_=
    posted_at = entry.updated > Time.zone.now ? Time.zone.now : entry.updated
    if title && location && remote?(location)
      return Job.new(title: title.strip,
                     posted_at: posted_at,
                     company: company.strip,
                     category: self.guess_category_from_title(title),
                     location: location.strip,
                     description: entry.content,
                     company_url: '',
                     original_post_url: link,
                     source: "Github Jobs")
    end
  end

  def self.remote?(location)
    ['anywhere','remote','united states','telecommute'].include?(location.downcase)
  end
end
