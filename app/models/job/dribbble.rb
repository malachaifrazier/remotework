class Job::Dribbble < Job
  def self.feed_urls
    ["https://dribbble.com/jobs.rss"]
  end

  def self.factory(entry, feed, opts={})
    link = entry.url.gsub(/^https:/, 'http:')
    company, remainder = entry.title.split(' is hiring a ')
    company, remainder = entry.title.split(' is hiring an ') if remainder.nil?
    title, location = remainder.split(' in ') if remainder.present?

    if remote?(location)
      if title && location && remote?(location)
        job = self.new(title: title.strip,
                       posted_at: entry.published,
                       company: company.strip,
                       location: location.strip,
                       description: '',
                       company_url: '',
                       original_post_url: link,
                       source: "Dribbble")
        category = "Design" 
        job.rebuild_tags!(category)
        return job
      end
    end
  end

  def self.remote?(location)
    /Remote/i.match(location) || /Anywhere/i.match(location)
  end

  def skip_description_scrape?
    true
  end
end
