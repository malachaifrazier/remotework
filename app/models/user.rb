# == Schema Information
#
# Table name: users
#
#  id                   :uuid             not null, primary key
#  created_at           :datetime
#  updated_at           :datetime
#  email                :string           not null
#  password_digest      :string           not null
#  password_reset_token :string
#  validation_token     :string
#  email_validated_at   :datetime
#  admin                :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_secure_password
  has_secure_token :password_reset_token
  has_secure_token :validation_token

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :password
  validates_length_of :password, minimum: 6, allow_blank: true,
   message: 'is too short (minimum is 6 characters).'

  has_many :jobs

  after_create :validate_email!
  after_create :send_notice

  def email_validated!
    touch(:email_validated_at)
  end

  def email_validated?
    self.email_validated_at.present?
  end

  def validate_email!
    self.regenerate_validation_token
    UserMailer.validate(self.id).deliver_later
  end

  def defaults_from_previous_job
    most_recent_job = self.jobs.order('created_at desc').limit(1).first
    return {} if most_recent_job.nil?
    {
      company: most_recent_job.company,
      location: most_recent_job.location,
      company_url: most_recent_job.company_url,
      company_description: most_recent_job.company_description,
      how_to_apply: most_recent_job.how_to_apply
    }
  end


  private

  def send_notice
    NoticeMailer.new_user_signup(self.id).deliver_later(queue: :low)
  end
end
