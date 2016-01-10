class Job < ActiveRecord::Base
  include FriendlyId
  include PgSearch
  include AASM
  friendly_id :name_for_slug, use: :slugged

  validates_presence_of :title
  validates_presence_of :company
  validates_presence_of :description

  belongs_to :user

  attr_accessor :category

  scope :unsent_daily, ->() { where(sent_daily_alerts_at: nil) }
  scope :next_up_for_tweet, -> { where("posted_at > ?", 7.days.ago).posted.order('last_tweeted_at DESC') }
  scope :featured, ->() { where(type: 'Job::RemotelyAwesome') }
  scope :not_featured, ->() { where("type <> 'Job::RemotelyAwesome'") }
  scope :not_ours, ->() { where("type <> 'Job::RemotelyAwesome'") }
  scope :ours, ->() { where("type = 'Job::RemotelyAwesome'") }
  scope :today, ->() { where("posted_at >= NOW() - '1 day'::INTERVAL") }
  scope :before_today, ->() { where("posted_at < NOW() - '1 day'::INTERVAL") }
  scope :this_week, ->() { where("posted_at > NOW() - '1 week'::INTERVAL") }
  scope :should_be_expired, ->() { where("expires_at < NOW()") }
  scope :expires_tomorrow, ->() { where("expires_at > NOW() AND expires_at < NOW() + '1 day'::INTERVAL") }
  scope :for_tags, ->(tags) {
    return where('1=1') if tags.blank?
    tags_pg = "{#{tags.join(',')}}"
    where("tags @> ?", tags_pg)
  }
  scope :similar, ->(job, number=3) {
    category = job.category
    language = job.tags_that_are('language').first
    Job.for_tags([category, language]).where('id != ?', job.id).limit(number)
  }
  
  pg_search_scope :search, against: [:title, :company, :description], using: { tsearch: { tsvector_column: "tsv" } }

  # pseudo-scope. Using a class method instead because we need to override this in a child class.
  def self.probable_duplicate(other_job)
    at = other_job.posted_at
    sql = <<-SQL
        title ILIKE ?
    AND company ILIKE ?
    AND (
          ((posted_at - ?) < INTERVAL '14 DAYS' AND (posted_at - ?) >= '0 SECONDS') OR
          ((posted_at - ?) > INTERVAL '-14 DAYS' AND (posted_at - ?) <= '0 SECONDS')
        )
    SQL
    where(sql, other_job.title, other_job.company, at, at, at, at)
  end

  aasm column: 'status' do
    state :pending, initial: true
    state :paused
    state :posted
    state :expired
    state :dead

    event :post do
      before do
        touch(:posted_at) if posted_at.nil?
        update_attribute(:expires_at, Time.zone.now + 30.days)
      end
      transitions from: [:pending, :paused], to: :posted
      after do
        send_notice if self.respond_to?(:send_notice)
      end
    end

    event :pause do
      transitions from: [:pending, :posted], to: :paused
    end

    event :kill do
      transitions from: [:posted], to: :dead
    end

    event :expire do
      before do
        touch(:expired_at)
      end
      transitions from: [:pending, :posted], to: :expired
    end
  end

  def name_for_slug
    "#{self.company} #{self.title}"
  end

  def fetch_description!(url, tags=%w[div p ul li strong h2], strip=%w[img])
    begin
      self.description = BasicDescriptionScraper.scrape(url,tags,strip)
    rescue => e
      Rails.logger.error "Failed to process job description for #{url} : #{e.message}"
      Rails.logger.error e.backtrace.join("\n ")
    end
  end

  def rebuild_tags!(category, other=nil)
    tags = TagBuilder.new(category, self.title, self.description, other).tags
    self.tags = tags[:all]
  end

  def grouped_tags
    language_tags = (self.tags & TagBuilder::LANGUAGE_TAGS)
    library_tags = (self.tags & TagBuilder::LIBRARY_TAGS)
    tool_tags = (self.tags & TagBuilder::TOOL_TAGS)
    skill_tags = (self.tags & TagBuilder::SKILL_TAGS)
    language_tags + library_tags + tool_tags + skill_tags
  end

  def category
    (tags && TagBuilder::CATEGORY_TAGS).first
  end

  def tags_that_are(type)
    tags && TagBuilder.const_get("#{type.upcase}_TAGS")
  end
  
  def reviewed?
    reviewed_at.present?
  end

  def reviewed!
    touch(:reviewed_at)
  end

  def ours?
    source == 'Remotely Awesome Jobs'
  end

  def self.skip_description_scrape?
    false
  end
end
