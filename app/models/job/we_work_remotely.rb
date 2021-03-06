# == Schema Information
#
# Table name: jobs
#
#  id                    :integer          not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  category_id           :integer
#  title                 :string           not null
#  posted_at             :datetime
#  company               :string           not null
#  location              :string           not null
#  description           :text             not null
#  company_url           :string
#  original_post_url     :string
#  source                :string
#  slug                  :string
#  type                  :string
#  sent_daily_alerts_at  :datetime
#  sent_weekly_alerts_at :datetime
#  last_tweeted_at       :datetime
#  tags                  :text             default([]), is an Array
#  company_description   :text
#  how_to_apply          :text
#  user_id               :uuid
#  expires_at            :datetime
#  status                :string
#  reviewed_at           :datetime
#  expired_at            :datetime
#  tsv                   :tsvector
#

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

    def factory(entry, feed, opts={})
      entry_title = entry.title.split(':')
      company = entry_title.shift
      title = entry_title.join(' ')
      location = entry.summary.match(/^.*?<strong>Headquarters:<\/strong>(.*?)</m)[1]
      if company && title && location
        job = self.new(title: title.strip,
                       posted_at: entry.published,
                       company: company.strip,
                       location: location.strip,
                       description: entry.summary,
                       company_url: '',
                       original_post_url: entry.entry_id,
                       source: "We Work Remotely")
        category = determine_category(feed)
        job.rebuild_tags!(category)
        return job
      end
    end

    def determine_category(feed)
      URLS[feed.feed_url]
    end
  end
  
  def fetch_description!(url)
    # Just use what RSS gave us.
  end  
end
