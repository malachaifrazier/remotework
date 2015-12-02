class AddReviewedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :reviewed_at, :datetime
  end
end
