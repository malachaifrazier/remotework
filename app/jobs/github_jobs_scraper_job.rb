require 'open-uri'

class GithubJobsScraperJob < ActiveJob::Base
  queue_as :low

  SOURCE = 'Github Jobs'

  # TODO BREAK DOWN BY TYPE/CATS?
  def perform(opts = {})
    if opts[:purge] == true
      Job.where(source: SOURCE).delete_all
    end
    
    url = "https://jobs.github.com/positions.atom"
    feed = Feedjira::Feed.fetch_and_parse url
    feed.entries.each do |entry|
      link = entry.links.first
      entry_title = entry.title.split(' at ')
      title = entry_title.shift
      company, location =  entry_title.join(' ').split(' in ')

      # GitHub lies about its posting date and puts them in the future
      # sometimes. =_=
      posted = Time.zone.now
      if title && location && remote?(location)
        job = Job.new(title: title.strip,
                      posted: posted,
                      company: company.strip,
                      category: Category.web,                  # TODO
                      location: location.strip,
                      description: entry.content,
                      company_url: '',
                      original_post_url: entry.entry_id,
                      source: "Github Jobs")
        job.save!
      end
    end
  end

  def remote?(location)
    ['Anywhere','Remote','United States','Telecommute'].include?(location)
  end
end
