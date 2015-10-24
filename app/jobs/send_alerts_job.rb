class SendAlertsJob < ActiveJob::Base
  queue_as :low

  def perform(frequency, opts={})
    raise ArgumentError unless ['daily','weekly'].include?(frequency)

    timestamp_column = "sent_#{frequency}_alerts_at"
    Alert.active.where(frequency: frequency).each do |alert|
      job_ids = Job.for_tags(alert.tags).where(timestamp_column => nil).pluck(:id)
      AlertMailer.digest(job_ids, alert).deliver_later
    end
    Job.where(timestamp_column => nil).update_all(timestamp_column => Time.zone.now)
  end
end
