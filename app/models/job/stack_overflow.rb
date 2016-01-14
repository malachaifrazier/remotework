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

class Job::StackOverflow < Job
  def self.feed_urls
    ["http://careers.stackoverflow.com/jobs/feed?allowsremote=True"]
  end

  def self.factory(entry, feed, opts={})
    match_data = entry.title.match(/(.*?) at (.*?)\((.*?)\).*?$/)
    if match_data
      job = self.new(title: match_data[1].strip,
                     posted_at: entry.published,
                     company: match_data[2].strip,
                     location: match_data[3].strip,
                     description: entry.summary,
                     company_url: '',
                     original_post_url: entry.entry_id,
                     source: "Stack Overflow Careers")
      category = CategoryGuesser.guess_category_from_title(match_data[1].strip)
      job.rebuild_tags!(category, entry.categories.join(' '))
      return job
    end
  end

  def rebuild_tags!(category, other)
    self.tags = TagBuilder.new(category, self.title, self.description, other).tags[:all]
  end

  def fetch_description!(url)
    super(url, %w[div p ul li strong h2], %w['a.learn-more', 'ul.joeltest', 'div.benefits-list'])
  end
end
