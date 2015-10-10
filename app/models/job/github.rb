class Job::Github < Job
  def self.feed_urls
    ["https://jobs.github.com/positions.atom"]
  end

  def self.factory(entry)
    link = entry.links.first.gsub(/^http:/, 'https:')
    entry_title = entry.title.split(' at ')
    title = entry_title.shift
    company, location =  entry_title.join(' ').split(' in ')

    # GitHub lies about its posting date and puts them in the future
    # sometimes. =_=
    posted = Time.zone.now
    if title && location && remote?(location)
      return Job.new(title: title.strip,
                     posted: posted,
                     company: company.strip,
                     category: Category.web,                  # TODO
                     location: location.strip,
                     description: entry.content,
                     company_url: '',
                     original_post_url: link,
                     source: "Github Jobs")
    end
  end

  def self.remote?(location)
    ['Anywhere','Remote','United States','Telecommute'].include?(location)
  end
end
