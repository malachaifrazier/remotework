class ExpirationMailer < ApplicationMailer
  layout "transactional_email"
  
  def tomorrow(job_id)
    @job = Job.find(job_id)
    return unless @job.ours?
    email = @job.user.email
    mail(to: email, subject: "Your Remotely Awesome Job post expires tomorrow", from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end

  def expired(job_id)
    @job = Job.find(job_id)
    return unless @job.ours?
    email = @job.user.email
    mail(to: email, subject: "Your Remotely Awesome Job post has expired", from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>")
  end
end
