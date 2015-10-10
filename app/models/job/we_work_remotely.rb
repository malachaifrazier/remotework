class Job::WeWorkRemotely < Job
  CATEGORIES = { '2' => Category.web, '3' => Category.design, '4' => Category.web, '5' => Category.mobile, '6' => Category.management }

  def self.feed_urls
    ["https://weworkremotely.com/jobs.rss"]
  end

  def self.factory(entry)
    entry_title = entry.title.split(':')
    company = entry_title.shift
    title = entry_title.join(' ')
    location = entry.summary.match(/^.*?<strong>Headquarters:<\/strong>(.*?)</m)[1]
    if company && title && location
      return Job.new(title: title.strip,
                     posted: entry.published,
                     company: company.strip,
                     category: Category.web,                  # TODO
                     location: location.strip,
                     description: entry.summary,
                     company_url: '',
                     original_post_url: entry.entry_id,
                     source: "We Work Remotely")
    end
  end
end
