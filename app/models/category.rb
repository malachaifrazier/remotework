class Category < ActiveRecord::Base

  def self.web
    self.find_by(name: 'Web Development')
  end

  def self.mobile
    self.find_by(name: 'Mobile Development')
  end

  def self.design
    self.find_by(name: 'Design')
  end

  def self.management
    self.find_by(name: 'Management')
  end
end
