class NoticeMailer < ApplicationMailer
  def new_alert_signup(alert_id)
    alert = Alert.find(alert_id)
    email = alert.email_address.email
    tags = alert.tags.present? ? alert.tags.to_sentence : '(none)'
    query = alert.search_query.present? ? alert.search_query : '(none)'
    frequency = alert.frequency
    body = "Email address #{email} has requested alerts\n\nTags: #{tags}\n\nSearch query: #{query}\n\nFrequency: #{frequency}"
    mail(to: 'notice@remotelyawesomejobs.com', subject: "Notice: New alert signup: #{email}", from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>", body: body)
  end

  def new_user_signup(user_id)
    user = User.find(user_id)
    body = "New user signup: #{user.email}"
    mail(to: 'notice@remotelyawesomejobs.com', subject: "Notice: New user signup: #{user.email}", from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>", body: body)
  end

  def new_job_posted(job_id)
    job = Job.find(job_id)
    body = "New job posted:\n\nTitle: #{job.title}\nCompany: #{job.company}\nTags: #{job.tags.to_sentence}\nUser: #{job.user.email}\nLink: https://www.remotelyawesomejobs.com/job/#{job.slug}"
    mail(to: 'notice@remotelyawesomejobs.com', subject: "Notice: New job post: #{job.title} at #{job.company}", from: "Remotely Awesome Jobs <no-reply@remotelyawesomejobs.com>", body: body)
  end
end
