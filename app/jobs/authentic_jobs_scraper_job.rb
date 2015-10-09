class AuthenticJobsScraperJob < ActiveJob::Base
  queue_as :low

  # TODO BREAK DOWN BY TYPE/CATS?

  CATEGORIES = { '2' => Category.web, '3' => Category.design, '4' => Category.web, '5' => Category.mobile, '6' => Category.management }

  def perform(*args)
    # TODO
    # Job.delete_all

    CATEGORIES.keys.each do |category|
      url = "http://www.authenticjobs.com/rss/custom.php?terms=&type=1,2,3,4,5,6,7&cats=#{category}&onlyremote=1&location="
      feed = Feedjira::Feed.fetch_and_parse url
      feed.entries.each do |entry|
        company, title = entry.title.split(': ')
        location = entry.summary.match(/.*?<strong>\((.*?)\)<\/strong>/)[1]
        job = Job.new(title: title,
                      posted: entry.published,
                      company: company,
                      category: CATEGORIES[category],
                      location: location,
                      description: entry.summary,
                      company_url: '',
                      original_post_url: entry.entry_id,
                      source: "Authentic Jobs")
        job.save!
      end
    end
  end
end
