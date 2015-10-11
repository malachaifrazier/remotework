class Job < ActiveRecord::Base
  include FriendlyId
  friendly_id :name_for_slug, use: :slugged
  acts_as_taggable

  belongs_to :category

  scope :probable_duplicate, ->(other_job) {
    at = other_job.posted_at
    sql = <<-SQL
        title ILIKE ?
    AND company ILIKE ?
    AND (
          ((posted_at - ?) < INTERVAL '24 HOURS' AND (posted_at - ?) >= '0 SECONDS') OR
          ((posted_at - ?) > INTERVAL '-24 HOURS' AND (posted_at - ?) <= '0 SECONDS')
        )
    SQL
    where(sql, other_job.title, other_job.company, at, at, at, at)
  }

  scope :for_category, ->(category) {
    return where('1=1') if category.nil?
    where(category: category)
  }

  def self.skip_description_scrape?
    false
  end

  def name_for_slug
    "#{self.company} #{self.title}"
  end

  def self.guess_category_from_title(title)
    # Some boards don't have any type of category on their job postings (yuck!). We've gotta
    # make a guess based on keywords the job title (yuck).  Order in the array is important
    # here - you want "Software Engineer Manager" to end up in management, not development.
    # Likewise you *probably* want "Public Relations Management" to be in other, not
    # management.
    all_keywords = [
      [ ['devops','sales','payroll','counsel','public relations','accountant','controller','tax','system administrator','writer','database'], Category.other ],
      [ ['manager','director','scrum','vp'], Category.management ],
      [ ['engineer','engineers','developer','developers','architect','programmer','programmers','dev'], Category.development ],
      [ ['designer','ux','ui','creative'], Category.design ]
    ]

    all_keywords.each do |keyword_map|
      keywords = keyword_map.first
      category = keyword_map.last
      clean_title_words = title.downcase.gsub(/[^a-z\s\-]/, '').gsub('-',' ').split(' ')
      return category if ! (clean_title_words & keywords).empty?
    end
    Category.other
  end
end
