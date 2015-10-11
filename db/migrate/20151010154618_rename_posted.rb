class RenamePosted < ActiveRecord::Migration
  def change
    rename_column :jobs, :posted, :posted_at
  end
end
