class Job < ActiveRecord::Base
  include FriendlyId
  friendly_id :name_for_slug, use: :slugged
  acts_as_taggable

  belongs_to :category

  def self.skip_description_scrape?
    false
  end

  def name_for_slug
    "#{self.company} #{self.title}"
  end
end
