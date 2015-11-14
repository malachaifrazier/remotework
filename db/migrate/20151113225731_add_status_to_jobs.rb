class AddStatusToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :status, :string
    Job.find_each do |job|
      user = job.user      
      if job.posted_at.present?
        job.update_column(:status, 'posted')
      elsif user && user.email_validated_at.present?
        job.update_column(:status, 'paused')
      else
        job.update_column(:status, 'pending')
      end
    end
  end

  def down
    remove_column :jobs, :status, :string
  end
end
