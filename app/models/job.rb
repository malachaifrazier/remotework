class Job < ActiveRecord::Base
  include FriendlyId
  friendly_id :name_for_slug, use: :slugged

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
    tags_pg = "{#{tags.join(',')}}"
    where("tags @> ?", tags_pg)
  }

  scope :unsent_daily, ->() { where(sent_daily_alerts_at: nil) }

  scope :next_up_for_tweet, -> { where("posted_at > ?", 7.days.ago).order('last_tweeted_at DESC') }

  def self.skip_description_scrape?
    false
  end

  def name_for_slug
    "#{self.company} #{self.title}"
  end

  def rebuild_tags!(other=nil)
    tags = TagBuilder.new(self.title, self.description).tags
    self.tags = tags[:all]
  end

  def grouped_tags
    language_tags = (self.tags & TagBuilder::LANGUAGE_TAGS)
    library_tags = (self.tags & TagBuilder::LIBRARY_TAGS)
    tool_tags = (self.tags & TagBuilder::TOOL_TAGS)
    skill_tags = (self.tags & TagBuilder::SKILL_TAGS)
    language_tags + library_tags + tool_tags + skill_tags
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
