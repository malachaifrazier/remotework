class Job::StackOverflow < Job
  def self.feed_urls
    ["http://careers.stackoverflow.com/jobs/feed?allowsremote=True"]
  end

  def self.factory(entry)
    match_data = entry.title.match(/(.*?) at (.*?)\((.*?)\).*?$/)
    if match_data
      return Job.new(title: match_data[1].strip,
                     posted: entry.published,
                     company: match_data[2].strip,
                     category: Category.web,                  # TODO
                     location: match_data[3].strip,
                     description: entry.summary,
                     company_url: '',
                     original_post_url: entry.entry_id,
                     source: "Stack Overflow Careers")
    end
  end
end
