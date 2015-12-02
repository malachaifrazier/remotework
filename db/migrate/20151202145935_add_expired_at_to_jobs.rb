class AddExpiredAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :expired_at, :datetime
  end
end
