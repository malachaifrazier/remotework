class EmailAddress < ActiveRecord::Base
  has_many :alerts
  validates_presence_of :email
  validates_email_format_of :email

  scope :subscribed, ->() { where(unsubscribed_at: nil) }
  scope :validated,  ->() { where("validated_at IS NOT NULL") }

  uniquify :validation_token, :length => 64, :omit => %w(i j l o 1 0 q)
  uniquify :login_token, :length => 64, :omit => %w(i j l o 1 0 q)

  def self.subscribe!(email)
    # UPSERTish thing. Would be great if we could do real UPSERTs
    begin
      create(email: email)
    rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
      e = find_by(email: email)
      e.update(unsubscribed_at: nil)
      e
    end
  end

  def unsubscribe!
    self.touch(:unsubscribed_at)
  end

  def validate!
    self.touch(:validated_at)
  end
end
