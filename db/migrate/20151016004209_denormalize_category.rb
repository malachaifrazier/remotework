class DenormalizeCategory < ActiveRecord::Migration
  def change
    add_column :jobs, :category, :string
    drop_table :categories, force: :cascade
  end
end
