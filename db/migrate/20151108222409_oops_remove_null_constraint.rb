class OopsRemoveNullConstraint < ActiveRecord::Migration
  def change
    change_column :jobs, :posted_at, :datetime, null: true
  end
end
