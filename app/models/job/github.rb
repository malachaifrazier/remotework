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

class Job::Github < Job
  # Because Github "cheats" and puts job posts w/ future dates,
  # we use the date we ingest their jobs as the posting date.
  # HOWEVER, that means we don't detect them as duplicates when
  # we try to re-ingest them again a few days later. For that
  # reason, we override the scope for Github and make the date
  # window a lot wider.
  # pseudo-scope. Using a class method instead because we need to override this in a child class.
  def self.probable_duplicate(other_job)
    at = other_job.posted_at
    sql = <<-SQL
        title ILIKE ?
    AND company ILIKE ?
    AND (
          ((posted_at - ?) < INTERVAL '30 DAYS' AND (posted_at - ?) >= '0 SECONDS') OR
          ((posted_at - ?) > INTERVAL '-30 DAYS' AND (posted_at - ?) <= '0 SECONDS')
        )
    SQL
    where(sql, other_job.title, other_job.company, at, at, at, at)
  end

  def self.feed_urls
    ["https://jobs.github.com/positions.atom"]
  end

  def self.factory(entry, feed, opts={})
    link = entry.links.first.gsub(/^http:/, 'https:')
    entry_title = entry.title.split(' at ')
    title = entry_title.shift
    company, location =  entry_title.join(' ').split(' in ')

    # GitHub lies about its posting date and puts them in the future
    # sometimes. =_=
    posted_at = entry.updated > Time.zone.now ? Time.zone.now : entry.updated
    if title && location && remote?(location)
      job = self.new(title: title.strip,
                     posted_at: posted_at,
                     company: company.strip,
                     location: location.strip,
                     description: entry.content,
                     company_url: '',
                     original_post_url: link,
                     source: "Github Jobs")
      category = CategoryGuesser.guess_category_from_title(title)
      job.rebuild_tags!(category)
      return job
    end
  end

  def self.remote?(location)
    ['anywhere','remote','united states','telecommute'].include?(location.downcase)
  end
end
