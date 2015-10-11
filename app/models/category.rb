class Category < ActiveRecord::Base
  has_many :jobs
  
  def self.development
    @@development ||= self.find_by(name: 'Development')
  end

  def self.design
    @@design ||= self.find_by(name: 'Design')
  end

  def self.management
    @@management ||= self.find_by(name: 'Management')
  end

  def self.other
    @@other ||= self.find_by(name: 'Other')
  end
end
