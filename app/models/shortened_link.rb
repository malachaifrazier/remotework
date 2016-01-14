# == Schema Information
#
# Table name: shortened_links
#
#  id    :integer          not null, primary key
#  short :string           not null
#  long  :string           not null
#

class ShortenedLink < ActiveRecord::Base
  validates_uniqueness_of :short
  validates_presence_of :short, :long
end
