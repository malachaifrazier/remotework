class AddExpiresAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :expires_at, :datetime
  end
end
