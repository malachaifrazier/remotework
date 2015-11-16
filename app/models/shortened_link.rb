class ShortenedLink < ActiveRecord::Base
  validates_uniqueness_of :short
  validates_presence_of :short, :long
end
