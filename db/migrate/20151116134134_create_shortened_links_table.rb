class CreateShortenedLinksTable < ActiveRecord::Migration
  def change
    create_table :shortened_links do |t|
      t.string :short, null: false
      t.string :long,  null: false
    end
  end
end
