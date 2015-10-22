class AddLastTweetedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :last_tweeted_at, :datetime
  end
end
