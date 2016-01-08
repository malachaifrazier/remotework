class Job::Jobspresso < Job
  URLS = {
    "https://jobspresso.co/?feed=job_feed&job_types=designer&search_location&job_categories&search_keywords" => 'design',
    "https://jobspresso.co/?feed=job_feed&job_types=developer&search_location&job_categories&search_keywords" => 'development',
    "https://jobspresso.co/?feed=job_feed&job_types=project-mgmt&search_location&job_categories&search_keywords" => 'management',
    "https://jobspresso.co/?feed=job_feed&job_types=marketing%2Csales%2Csupport%2Csys-admin%2Ctester&search_location&job_categories&search_keywords" => 'other'
  }
  
  class << self
    def feed_urls
      URLS.keys
    end

    def factory(entry, feed, opts={})
      company = ''
      location = 'Anywhere'
      job = self.new(title: entry.title.strip,
                     posted_at: entry.published,
                     company: get_company_name(entry.url),
                     location: location.strip,
                     description: entry.content,
                     company_url: '',
                     original_post_url: entry.url,
                     source: "Jobspresso")
      category = determine_category(feed)
      job.rebuild_tags!(category)
      return job
    end

    def determine_category(feed)
      URLS[feed.feed_url]
    end
    
    def fetch_description!(url)
      super(url, %w[div p ul li b br strong h2 h3])
    end

    def get_company_name(url)
      doc = Nokogiri::HTML(open(url))
      doc.search('.job-company a').text
    end
  end
end
