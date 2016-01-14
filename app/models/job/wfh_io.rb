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

  def fetch_description!(url)
    # Just use what RSS gave us.
  end    
end
