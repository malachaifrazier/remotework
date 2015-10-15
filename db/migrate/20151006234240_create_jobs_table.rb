class CreateJobsTable < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.timestamps
      t.string      :name
    end

    Category.create!(name: 'Web Development')
    Category.create!(name: 'Mobile Development')
    Category.create!(name: 'Design')
    Category.create!(name: 'Management')

    create_table :jobs do |t|
      t.timestamps
      t.references  :category
      t.string      :title,             null: false
      t.datetime    :posted,            null: false
      t.string      :company,           null: false
      t.string      :location,          null: false
      t.text        :description,       null: false
      t.string      :company_url
      t.string      :original_post_url
      t.string      :source
    end

    add_foreign_key :jobs, :categories
  end
end
