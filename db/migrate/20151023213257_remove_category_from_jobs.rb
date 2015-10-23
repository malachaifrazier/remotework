class RemoveCategoryFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :category
    remove_column :alerts, :category
  end

  def down
    add_column :jobs, :category, :string
    add_column :alerts, :category, :string
  end
end
