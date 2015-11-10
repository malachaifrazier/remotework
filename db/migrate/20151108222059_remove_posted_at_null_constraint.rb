class RemovePostedAtNullConstraint < ActiveRecord::Migration
  def change
    change_column :jobs, :posted_at, :datetime, null: false
  end
end
