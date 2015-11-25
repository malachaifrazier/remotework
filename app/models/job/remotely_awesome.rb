class Job::RemotelyAwesome < Job
  belongs_to :user
  after_initialize :init
  
  def init
    self.source = 'Remotely Awesome Jobs'
  end

  def send_notice
    NoticeMailer.new_job_posted(self.id).deliver_later(queue: :low)
  end
end
