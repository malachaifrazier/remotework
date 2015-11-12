class Job::RemotelyAwesome < Job
  belongs_to :user
  after_initialize :init
  
  def init
    self.source = 'Remotely Awesome Jobs'
  end
end
