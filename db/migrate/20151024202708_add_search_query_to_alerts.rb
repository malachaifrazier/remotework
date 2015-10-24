class AddSearchQueryToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :search_query, :string
  end
end
