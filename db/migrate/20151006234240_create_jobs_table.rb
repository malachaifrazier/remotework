class CreateJobsTable < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :categories do |t|
      t.timestamps
      t.string      :name
    end

    Category.create!(name: 'Web Development')
    Category.create!(name: 'Mobile Development')
    Category.create!(name: 'Design')
    Category.create!(name: 'Management')

    create_table :jobs, id: :uuid do |t|
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
      t.foreign_key :categories
    end
  end
end
