class AlertMailer < ApplicationMailer
  def digest(job_ids, alert)
    @jobs = Job.find(job_ids)
    @alert = alert
    @token = alert.email_address.login_token
    email = alert.email_address.email
    mail(to: email, subject: "Your Job Alert Digest", from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end
end
