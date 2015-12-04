require 'open-uri'
require 'open_uri_redirections'  # danger Will Robinson

class TwitterIngestionJob < ActiveJob::Base
  queue_as :low

  def perform(klasses, opts={})
    client = Twitter::REST::Client.new do |config|
      config.consumer_key =        ENV["RA_TWITTER_CONSUMER_KEY"]
      config.consumer_secret =     ENV["RA_TWITTER_CONSUMER_SECRET"]
      config.access_token =        ENV["RA_TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["RA_TWITTER_ACCESS_TOKEN_SECRET"]
    end

    ActiveRecord::Base.connection_pool.with_connection do
      Job.delete_all if opts[:purge_all]
      klasses = [klasses] unless klasses.is_a?(Array)
      klasses.each do |klass|
        Rails.logger.info "Processing jobs from #{klass}"
        klazz = klass.constantize
        klazz.twitter_handles.each do |twitter_handle|
          Rails.logger.info "Reading Twitter Handle @#{twitter_handle}"
          klazz.delete_all if opts[:purge_source]
          client.user_timeline(twitter_handle, exclude_replies: true, include_rts: false).each do |tweet|
            job = klazz.factory(tweet)
            if job
              job.original_post_url = normalize_url(job.original_post_url)
              job.description = fetch_description(job.original_post_url) unless klazz.skip_description_scrape?
              job.save! unless klazz.probable_duplicate(job).exists?
              job.post!
            end
          end
        end
      end
    end
  end

  def fetch_description(url)
    begin
      source = open(url, allow_redirections: :safe).read
      result = Readability::Document.new(source, blacklist: %w[img], tags: %w[div p ul li strong h2]).content
    rescue => e
      Rails.logger.error "Failed to process job description for #{url} : #{e.message}"
    end
  end

  def normalize_url(url)
    url = ActiveSupport::Inflector.transliterate(url)
    if /\/t\.co\//.match(url)
      # We have a shortened twitter link. Try to tease out a canonical URL from the Job posting.
      source = open(url, allow_redirections: :safe).read
      begin
        url = Nokogiri::HTML(open(url, allow_redirections: :safe)).css('link[rel=canonical]').attribute('href').value()
      rescue
        Rails.logger.info "Unable to get the canonical URL for the job post."
      end
    end
    url
  end
end
