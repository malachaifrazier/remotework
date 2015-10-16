class Job::WeWorkRemotely < Job
  URLS = {
    "https://weworkremotely.com/categories/1-design/jobs.rss" => 'design',
    "https://weworkremotely.com/categories/2-programming/jobs.rss" => 'development',
    "https://weworkremotely.com/categories/3-business-exec-management/jobs.rss" => 'management',
    "https://weworkremotely.com/categories/4-remote/jobs.rss" => 'other',
    "https://weworkremotely.com/categories/5-copywriting/jobs.rss" => 'other',
    "https://weworkremotely.com/categories/6-devops-sysadmin/jobs.rss" => 'other',
    "https://weworkremotely.com/categories/7-customer-support/jobs.rss" => 'other',
    "https://weworkremotely.com/categories/9-marketing/jobs.rss"  => 'other'
  }

  class << self
    def feed_urls
      URLS.keys
    end

    def skip_description_scrape?
      true
    end

    def factory(entry, feed, opts={})
      entry_title = entry.title.split(':')
      company = entry_title.shift
      title = entry_title.join(' ')
      location = entry.summary.match(/^.*?<strong>Headquarters:<\/strong>(.*?)</m)[1]
      if company && title && location
        job = self.new(title: title.strip,
                       posted_at: entry.published,
                       company: company.strip,
                       category: determine_category(feed),
                       location: location.strip,
                       description: entry.summary,
                       company_url: '',
                       original_post_url: entry.entry_id,
                       source: "We Work Remotely")
        job.rebuild_tags!
        return job
      end
    end

    def determine_category(feed)
      URLS[feed.feed_url]
    end
  end
end
