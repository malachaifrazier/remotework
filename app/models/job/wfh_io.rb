class Job::WfhIo < Job
  URLS = {
    "https://www.wfh.io/categories/3-remote-customer-support/jobs.atom" => 'other',
    "https://www.wfh.io/categories/4-remote-design/jobs.atom" => 'design',
    "https://www.wfh.io/categories/6-remote-devops/jobs.atom" => 'other',
    "https://www.wfh.io/categories/9-remote-marketing/jobs.atom" => 'management',
    "https://www.wfh.io/categories/10-remote-network-security/jobs.atom" => 'other',
    "https://www.wfh.io/categories/5-remote-other/jobs.atom" => 'other',
    "https://www.wfh.io/categories/8-remote-quality-assurance/jobs.atom" => 'other',
    "https://www.wfh.io/categories/1-remote-software-development/jobs.atom" => 'development',
    "https://www.wfh.io/categories/2-remote-system-administration/jobs.atom" => 'other'
  }

  class << self
    def feed_urls
      URLS.keys
    end

    def skip_description_scrape?
      true
    end

    def factory(entry, feed, opts={})
      title_paramed = entry.title.parameterize
      # Crazy way to extract the company name from the slug.
      company = entry.url.gsub(title_paramed,'').split('-').drop(1).join(' ').strip.titleize
      if company
        job = self.new(title: entry.title.strip,
                       posted_at: entry.published,
                       company: company,
                       location: 'Anywhere',
                       description: entry.content,
                       company_url: '',
                       original_post_url: entry.url,
                       source: "WFH.io")
        category = determine_category(feed)
        job.rebuild_tags!(category)
        return job
      end
    end

    def determine_category(feed)
      URLS[feed.feed_url]
    end
  end
end
