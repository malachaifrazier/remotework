class Job::Angellist < Job
  class << self
    def factory(entry, opts={})
      title = entry.css('.title a[target=_blank]').text
      company = entry.css('a.startup-link').text
      original_post_url = entry.css('.title a[target=_blank]').attr('href')
      location = entry.css('div.tag.locations').text
      summary = entry.css('div.content div.description').text
      original_tags = entry.css('.tags').text
      website = entry.css('a.website-link').attr('href')
      if company && title && location && original_post_url
        job = self.new(title: title.strip,
                       posted_at: Time.zone.now,
                       company: company.strip,
                       location: location.strip,
                       description: summary,
                       company_url: website,
                       original_post_url: original_post_url,
                       source: "AngelList")
        category = CategoryGuesser.guess_category_from_title(title)
        job.rebuild_tags!(category, original_tags)
        return job
      end
    end
  end
end
