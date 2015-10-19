class Alert < ActiveRecord::Base
  belongs_to :email_address
  validates_presence_of :email_address

  scope :active, ->() { where(active: true) }
end
