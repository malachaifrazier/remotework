require 'open-uri'
require 'open_uri_redirections'  # danger Will Robinson

# AngelList is a major PITA and doesn't like to share its data. Good
# thing I'm not above sloppy pragmatic hackery when it's needed.
class AngellistIngestionJob < ActiveJob::Base
  queue_as :low

  def perform(opts={})
    ActiveRecord::Base.connection_pool.with_connection do
      Job.delete_all if opts[:purge_all]
      Rails.logger.info "Processing AngelList"
      doc = Nokogiri::HTML(open("https://angel.co/job-collections/remote"))
      entries = doc.css('.job-list-item')
      entries.each do |entry|
        entry.css('.listing-row').each do |listing|
          job = Job::Angellist.factory(listing, parent: entry)
          if job && !Job.probable_duplicate(job).exists?
            job.fetch_description!(job.original_post_url)
            job.save!
            job.post!
          end
        end
      end
    end
  end

  def normalize_url(url)
    ActiveSupport::Inflector.transliterate(url.gsub('https','http'))    
  end
end
