require 'open-uri'

class RssIngestionJob < ActiveJob::Base
  queue_as :low

  def perform(klasses, opts={})
    Job.delete_all if opts[:purge_all]
    klasses = [klasses] unless klasses.is_a?(Array)

    klasses.each do |klass|
      klass.feed_urls.each do |feed_url|
        feed = Feedjira::Feed.fetch_and_parse feed_url
        feed.entries.each do |entry|
          job = klass.factory(entry, feed)
          if job
            job.description = fetch_description(job.original_post_url) unless klass.skip_description_scrape?
            job.save! unless Job.probable_duplicate(job).exists?
          end
        end
      end
    end
  end

  def fetch_description(url)
    url = normalize_url(url)
    source = open(url).read
    Readability::Document.new(source, blacklist: %w[img], tags: %w[div p ul li strong h2]).content
  end

  def normalize_url(url)
    ActiveSupport::Inflector.transliterate(url)
  end
end
