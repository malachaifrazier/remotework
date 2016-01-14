# == Schema Information
#
# Table name: jobs
#
#  id                    :integer          not null, primary key
#  created_at            :datetime
#  updated_at            :datetime
#  category_id           :integer
#  title                 :string           not null
#  posted_at             :datetime
#  company               :string           not null
#  location              :string           not null
#  description           :text             not null
#  company_url           :string
#  original_post_url     :string
#  source                :string
#  slug                  :string
#  type                  :string
#  sent_daily_alerts_at  :datetime
#  sent_weekly_alerts_at :datetime
#  last_tweeted_at       :datetime
#  tags                  :text             default([]), is an Array
#  company_description   :text
#  how_to_apply          :text
#  user_id               :uuid
#  expires_at            :datetime
#  status                :string
#  reviewed_at           :datetime
#  expired_at            :datetime
#  tsv                   :tsvector
#

require 'rails_helper'

describe Job do
  describe '.probable_duplicate' do
    let!(:job_a) { FactoryGirl.create(:job, title: 'Guitar Man', company: "Jack's", posted_at: Date.new(1967,1,1)) }
    let (:job_b) { FactoryGirl.build(:job, title: 'Guitar Man', company: "Jack's", posted_at: Date.new(1967,1,1)) }

    it "should call it a duplicate: same title, same company, same day" do
      expect(Job.probable_duplicate(job_b).exists?).to be true
    end

    it "should call it a duplicate: same title, same company, 13 days ago" do
      job_b.posted_at = job_a.posted_at + 13.days
      expect(Job.probable_duplicate(job_b).exists?).to be true      
    end

    it "should not call it a duplicate: same title, same company, 14 days ago" do
      job_b.posted_at = job_a.posted_at + 14.days
      expect(Job.probable_duplicate(job_b).exists?).to be false
    end

    it "should call it a duplicate: same title w/ different case, same company w/ different case" do
      job_b.title = job_a.title.upcase
      job_b.company = job_a.company.upcase
      expect(Job.probable_duplicate(job_b).exists?).to be true      
    end
  end

  describe "#post!" do
    let (:job) { FactoryGirl.create(:job, title: 'Guitar Man', company: "Jack's", posted_at: nil) }
    it "should update posted_at" do
      job.post!
      job.reload
      expect(job.posted_at).not_to be_nil
    end
  end

  describe "#expire!" do
    let (:job) { FactoryGirl.create(:job, title: 'Guitar Man', company: "Jack's") }
    it "should update posted_at" do
      job.post!
      job.expire!
      job.reload
      expect(job.expired_at).not_to be_nil
    end    
  end

  describe "review!" do
    let (:job) { FactoryGirl.create(:job, title: 'Guitar Man', company: "Jack's") }
    it "should update posted_at" do
      job.reviewed!
      job.reload
      expect(job.reviewed_at).not_to be_nil
    end    
  end
end
