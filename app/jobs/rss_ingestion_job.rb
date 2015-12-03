require 'open-uri'
require 'open_uri_redirections'  # danger Will Robinson

class RssIngestionJob < ActiveJob::Base
  queue_as :low

  def perform(klasses, opts={})
    ActiveRecord::Base.connection_pool.with_connection do
      Job.delete_all if opts[:purge_all]
      klasses = [klasses] unless klasses.is_a?(Array)

      klasses.each do |klass|
        Rails.logger.info "Processing jobs from #{klass}"
        klazz = klass.constantize
        klazz.feed_urls.each do |feed_url|
          Rails.logger.info "Reading URL #{feed_url}"
          klazz.delete_all if opts[:purge_source]
          feed = Feedjira::Feed.fetch_and_parse feed_url
          feed.entries.each do |entry|
            begin
              job = klazz.factory(entry, feed)
              if job
                unless klazz.probable_duplicate(job).exists?
                  unless klazz.skip_description_scrape?
                    job.description = fetch_description(job.original_post_url) 
                    category = Job.guess_category_from_title(entry.title)
                    job.rebuild_tags!(category, entry.categories.join(' '))
                  end
                  job.save! 
                  job.post!
                end
              end
            rescue => e
              Rails.logger.error "Failed to fetch job on #{feed_url}, entry #{entry.inspect}"
              Rails.logger.error "Got exception: #{e.message}"
              Rails.logger.error e.backtrace.join("\n ")
            end
          end
        end
      end
    end
  end

  def fetch_description(url)
    url = normalize_url(url)
    begin
      source = open(url, allow_redirections: :all).read
      Readability::Document.new(source, blacklist: %w[img], tags: %w[div p ul li strong h2]).content
    rescue => e
      Rails.logger.error "Failed to process job description for #{url} : #{e.message}"
    end
  end

  def normalize_url(url)
    ActiveSupport::Inflector.transliterate(url)
  end
end
