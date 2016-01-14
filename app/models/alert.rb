# == Schema Information
#
# Table name: alerts
#
#  id               :uuid             not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  email_address_id :uuid             not null
#  tags             :text             default([]), is an Array
#  last_sent_at     :datetime
#  active           :boolean          default(TRUE), not null
#  frequency        :string           not null
#  search_query     :string
#

class Alert < ActiveRecord::Base
  belongs_to :email_address
  validates_presence_of :email_address

  scope :active, ->() { joins(:email_address).where(active: true).where('email_addresses.unsubscribed_at IS NULL') }
  scope :daily,  ->() { where(frequency: "daily") }
  scope :weekly, ->() { where(frequency: "weekly") }

  after_create :send_notice


  private

  def send_notice
    NoticeMailer.new_alert_signup(self.id).deliver_later(queue: :low)
  end
end
