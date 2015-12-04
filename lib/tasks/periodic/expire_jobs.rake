# -*- coding: utf-8 -*-
namespace :periodic do
  desc "Expires old jobs"
  task :expire_jobs => :environment do
    Job.should_be_expired.find_each do |job|
      Rails.logger.info "Expiring #{job.title} at #{job.company}"
      job.expire!
      ExpirationMailer.expired(job.id).deliver_later(queue: :low) if job.ours?
    end

    Job.ours.expires_tomorrow.find_each do |job|
      ExpirationMailer.tomorrow(job.id).deliver_later(queue: :low)
    end    
  end
end
