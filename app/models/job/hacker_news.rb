class Job::HackerNews < Job
  class << self
    def feed_urls
      ["http://hnapp.com/rss?q=remote%20type%3Ajob%20%7C%20author%3Awhoishiring"]
    end

    def factory(entry, feed, opts={})
      cleaned_entry_title = entry.title.split(';')[1..-1].join.strip  # gets upvotes junk out.
      company = guess_company(cleaned_entry_title)
      if cleaned_entry_title && company
        job = self.new(title: cleaned_entry_title,
                       posted_at: entry.published,
                       company: company,
                       location: 'Anywhere',
                       description: entry.summary,
                       company_url: '',
                       original_post_url: entry.links[0],
                       source: "Hacker News")
        category = CategoryGuesser.guess_category_from_title(cleaned_entry_title)
        return job
      end
    end
    
    def guess_company(title)
      return 'Zidisha' if title =~ /Zidisha/i # these guys never follow the rules
      someone_is_hiring = title.split(/is hiring/i)
      if someone_is_hiring.size > 1
        return someone_is_hiring[0].gsub(/\(YC.*?\)/,'').strip
      end
      nil
    end
  end
end
