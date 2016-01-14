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
                       description: entry.title,
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
end
