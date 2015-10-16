class Job < ActiveRecord::Base
  include FriendlyId
  friendly_id :name_for_slug, use: :slugged
  acts_as_taggable_on :languages, :libraries, :tools, :skills

  validates_presence_of :category
  validates_presence_of :title
  validates_presence_of :company
  validates_presence_of :description

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
    return where('1=1') if category.blank?
    where(category: category)
  }

  scope :for_tags, ->(tags) {
    return where('1=1') if tags.blank?
    tagged_with(tags)
  }

  def self.skip_description_scrape?
    false
  end

  def name_for_slug
    "#{self.company} #{self.title}"
  end

  def rebuild_tags!(other=nil)
    tags = TagBuilder.new(self.title, self.description).tags
    self.language_list = tags[:language]
    self.library_list = tags[:library]
    self.tool_list = tags[:tools]
    self.skill_list = tags[:skills]
  end

  def self.guess_category_from_title(title)
    # Some boards don't have any type of category on their job postings (yuck!). We've gotta
    # make a guess based on keywords the job title (yuck).  Order in the array is important
    # here - you want "Software Engineer Manager" to end up in management, not development.
    # Likewise you *probably* want "Public Relations Management" to be in other, not
    # management.
    all_keywords = [
      [ ['devops','sales','payroll','counsel','public relations','accountant','controller','tax','system administrator','writer','database'], 'other' ],
      [ ['manager','director','scrum','vp'], 'management' ],
      [ ['engineer','engineers','developer','developers','architect','programmer','programmers','dev'], 'development' ],
      [ ['designer','ux','ui','creative'], 'design' ]
    ]

    all_keywords.each do |keyword_map|
      keywords = keyword_map.first
      category = keyword_map.last
      clean_title_words = title.downcase.gsub(/[^a-z\s\-]/, '').gsub('-',' ').split(' ')
      return category if ! (clean_title_words & keywords).empty?
    end
    'other'
  end
end
