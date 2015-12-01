# -*- coding: utf-8 -*-
require 'net/http'

namespace :periodic do
  desc "Finds dead links on page"
  task :find_404 => :environment do
    Job.posted.not_ours.find_each do |job|
      original_url = URI(job.original_post_url)
      Rails.logger.debug "Checking for 4xx status at #{job.original_post_url}"
      response_status = Net::HTTP.get_response(original_url)
      if response_status.code.first == '4'
        job.kill!
      end
    end
  end
end
