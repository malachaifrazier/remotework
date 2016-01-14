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

class Job::OffsiteCareers < Job
  class << self
    def feed_urls
      ["http://offsite.careers/feeds/jobs"]
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
        category = CategoryGuesser.guess_category_from_title(match_data[1].strip)
        job.rebuild_tags!(category, entry.categories.join(' '))
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
