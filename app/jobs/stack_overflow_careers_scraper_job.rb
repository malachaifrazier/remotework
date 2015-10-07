class StackOverflowCareersScraperJob < ActiveJob::Base
  queue_as :low

  # TODO BREAK DOWN BY TYPE/CATS?
  def perform(*args)
    # TODO
    Job.delete_all

    url = "http://careers.stackoverflow.com/jobs/feed?allowsremote=True"
    feed = Feedjira::Feed.fetch_and_parse url
    feed.entries.each do |entry|
      match_data = entry.title.match(/(.*?)at(.*?)\((.*?)\).*?$/)
      if match_data
        job = Job.new(title: match_data[1].strip,
                      posted: entry.published,
                      company: match_data[2].strip,
                      category: Category.web,                  # TODO
                      location: match_data[3].strip,
                      description: entry.summary,
                      company_url: '',
                      original_post_url: entry.entry_id,
                      source: "Stack Overflow Careers")
        job.save!
      end
    end
  end
end
