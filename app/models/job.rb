class Job < ActiveRecord::Base
  include FriendlyId
  friendly_id :name_for_slug, use: :slugged

  belongs_to :category

  def name_for_slug
    "#{self.company} #{self.title}"
  end
end
