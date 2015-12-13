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
end
