class Job::StackOverflow < Job
  def self.feed_urls
    ["http://careers.stackoverflow.com/jobs/feed?allowsremote=True"]
  end

  def self.factory(entry, feed, opts={})
    match_data = entry.title.match(/(.*?) at (.*?)\((.*?)\).*?$/)
    if match_data
      job = self.new(title: match_data[1].strip,
                     posted_at: entry.published,
                     company: match_data[2].strip,
                     category: self.guess_category_from_title(match_data[1].strip),
                     location: match_data[3].strip,
                     description: entry.summary,
                     company_url: '',
                     original_post_url: entry.entry_id,
                     source: "Stack Overflow Careers")
      job.rebuild_tags!(entry.categories.join(' '))
      return job
    end
  end

  def rebuild_tags!(other)
    tags = TagBuilder.new(self.title, self.description, other).tags
    self.language_list = tags[:language]
    self.library_list = tags[:library]
    self.tool_list = tags[:tools]
    self.skill_list = tags[:skills]
  end
end
