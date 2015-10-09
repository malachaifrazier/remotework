require 'open-uri'

class WeWorkRemotelyScraperJob < ActiveJob::Base
  queue_as :low

  def perform(*args)
    # TODO
    # Job.delete_all

    url = "https://weworkremotely.com/jobs.rss"
    feed = Feedjira::Feed.fetch_and_parse url
    feed.entries.each do |entry|
      entry_title = entry.title.split(':')
      company = entry_title.shift
      title = entry_title.join(' ')
      location = entry.summary.match(/^.*?<strong>Headquarters:<\/strong>(.*?)</m)[1]
      summary = fetch_description(entry.entry_id)
      if company && title && location && summary
        job = Job.new(title: title.strip,
                      posted: entry.published,
                      company: company.strip,
                      category: Category.web,                  # TODO
                      location: location.strip,
                      description: entry.summary,
                      company_url: '',
                      original_post_url: entry.entry_id,
                      source: "We Work Remotely")
        job.save!
      end
    end
  end

  def fetch_description(url)
    url = normalize_url(url)
    source = open(url).read
    clean = Readability::Document.new(source, blacklist: %w[img], tags: %w[div p ul li strong h2]).content
  end

  def normalize_url(url)
    ActiveSupport::Inflector.transliterate(url)
  end
end
