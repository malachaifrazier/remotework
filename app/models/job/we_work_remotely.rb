class Job::WeWorkRemotely < Job
  URLS = {
    "https://weworkremotely.com/categories/1-design/jobs.rss" => Category.design,
    "https://weworkremotely.com/categories/2-programming/jobs.rss" => Category.development,
    "https://weworkremotely.com/categories/3-business-exec-management/jobs.rss" => Category.management,
    "https://weworkremotely.com/categories/4-remote/jobs.rss" => Category.other,
    "https://weworkremotely.com/categories/5-copywriting/jobs.rss" => Category.other,
    "https://weworkremotely.com/categories/6-devops-sysadmin/jobs.rss" => Category.other,
    "https://weworkremotely.com/categories/7-customer-support/jobs.rss" => Category.other,
    "https://weworkremotely.com/categories/9-marketing/jobs.rss"  => Category.other
  }

  class << self
    def feed_urls
      URLS.keys
    end

    def factory(entry, feed, opts={})
      entry_title = entry.title.split(':')
      company = entry_title.shift
      title = entry_title.join(' ')
      location = entry.summary.match(/^.*?<strong>Headquarters:<\/strong>(.*?)</m)[1]
      if company && title && location
        return Job.new(title: title.strip,
                       posted_at: entry.published,
                       company: company.strip,
                       category: determine_category(feed),
                       location: location.strip,
                       description: entry.summary,
                       company_url: '',
                       original_post_url: entry.entry_id,
                       source: "We Work Remotely")
      end
    end

    def determine_category(feed)
      URLS[feed.feed_url]
    end
  end
end
