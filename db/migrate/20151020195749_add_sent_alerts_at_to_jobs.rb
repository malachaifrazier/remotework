class AddSentAlertsAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :sent_daily_alerts_at, :datetime
    add_column :jobs, :sent_weekly_alerts_at, :datetime
  end
end
