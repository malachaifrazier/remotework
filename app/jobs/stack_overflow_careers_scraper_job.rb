require 'open-uri'

class StackOverflowCareersScraperJob < ActiveJob::Base
  queue_as :low

  # TODO BREAK DOWN BY TYPE/CATS?
  def perform(*args)
    # TODO
    # Job.delete_all

    url = "http://careers.stackoverflow.com/jobs/feed?allowsremote=True"
    feed = Feedjira::Feed.fetch_and_parse url
    feed.entries.each do |entry|
      match_data = entry.title.match(/(.*?) at (.*?)\((.*?)\).*?$/)
      if match_data
        summary = fetch_description(entry.entry_id)
        job = Job.new(title: match_data[1].strip,
                      posted: entry.published,
                      company: match_data[2].strip,
                      category: Category.web,                  # TODO
                      location: match_data[3].strip,
                      description: summary,
                      company_url: '',
                      original_post_url: entry.entry_id,
                      source: "Stack Overflow Careers")
        job.save!
      end
    end
  end

  def fetch_description(url)
    url = normalize_url(url)
    source = open(url).read
    clean = Readability::Document.new(source, blacklist: '#joeltest', tags: %w[div p ul li strong h2]).content
    clean.gsub(/The Joel Test is a twelve-question measure of the quality of a software team./,'')
  end

  def normalize_url(url)
    ActiveSupport::Inflector.transliterate(url)
  end
end
