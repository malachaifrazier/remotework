class Job::Jobspresso < Job
  class << self
    def twitter_handles
      ['jobspresso']
    end

    def factory(tweet, opts={})
      text = tweet.full_text
      fields = text.split("\n")
      Rails.logger.info "PARSING #{text}"
      if fields.length == 4 && /\[(.*?)\]/.match(fields[0])
        Rails.logger.info "OK, passes... fields are #{fields.inspect}"
        location = /\[(.*?)\]/.match(fields[0])[1]
        job_line = fields[1]
        company = /(.*?)is hiring a.*?/.match(job_line)[1].gsub(/@.*?\s/,'').strip
        title = /.*?is hiring a (.*?)$/.match(job_line)[1]
        original_link = fields[3].split(' ').first
        if location.present? && company.present? && title.present? && original_link.present?
          job = self.new(title: title,
                         posted_at: tweet.created_at,
                         company: company,
                         location: location,
                         description: '',
                         company_url: '',
                         original_post_url: original_link,
                         source: "Jobspresso")
        end
      end
    end
  end

  def update_original_url!
    begin
      self.original_url = Nokogiri::HTML(self.description).css('link[rel=canonical]').attribute('href').value()
    rescue
    end
  end
end
