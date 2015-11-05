class AddCompanyFieldsToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :company_description, :text
    add_column :jobs, :how_to_apply, :text
  end
end
