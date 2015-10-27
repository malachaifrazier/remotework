namespace :periodic do
  desc "Downloads new job posts from Twitter"
  task :fetch_job_posts => :environment do
    TwitterIngestionJob.perform_later(['Job::Jobspresso'])
  end
end
