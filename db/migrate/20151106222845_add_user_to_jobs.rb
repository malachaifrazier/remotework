class AddUserToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :user_id, :uuid
    add_index  :jobs, :user_id
    add_foreign_key :jobs, :users
  end
end
