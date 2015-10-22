class Alert < ActiveRecord::Base
  belongs_to :email_address
  validates_presence_of :email_address

  scope :active, ->() { joins(:email_address).where(active: true).where('email_addresses.unsubscribed_at IS NULL') }
  scope :daily,  ->() { where(frequency: "daily") }
  scope :weekly, ->() { where(frequency: "weekly") }
end
