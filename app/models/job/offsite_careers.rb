class Job::OffsiteCareers < Job
  class << self
    def feed_urls
      ["http://offsite.careers/feeds/jobs"]
    end

    def skip_description_scrape?
      true
    end

    def factory(entry, feed, opts={})
      match_data = entry.title.match(/(.*?) at (.*?)\((.*?)\).*?$/)
      if match_data
        job = self.new(title: match_data[1].strip,
                       posted_at: entry.published,
                       company: match_data[2].strip,
                       location: match_data[3].strip,
                       description: entry.summary,
                       company_url: '',
                       original_post_url: entry.entry_id,
                       source: "offsite.careers")
        category = self.guess_category_from_title(match_data[1].strip)
        job.rebuild_tags!(category, entry.categories.join(' '))
        return job
      end
    end

    def determine_category(feed)
      URLS[feed.feed_url]
    end
  end
end
