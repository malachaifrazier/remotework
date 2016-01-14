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

class Job::Angellist < Job
  class << self
    def factory(entry, opts={})
      parent = opts[:parent]
      company = parent.css('a.startup-link').text
      location = parent.css('div.tag.locations').text
      summary = parent.css('div.content div.description').text
      website = parent.css('a.website-link').attr('href')      
      title = entry.css('.title a[target=_blank]').text
      original_post_url = entry.css('.title a[target=_blank]').attr('href')
      original_tags = entry.css('.tags').text
      if company && title && location && original_post_url
        job = self.new(title: title.strip,
                       posted_at: Time.zone.now,
                       company: company.strip,
                       location: location.strip,
                       description: summary,
                       company_url: website,
                       original_post_url: original_post_url,
                       source: "AngelList")
        category = CategoryGuesser.guess_category_from_title(title)
        job.rebuild_tags!(category, original_tags)
        return job
      end
    end
  end
end
