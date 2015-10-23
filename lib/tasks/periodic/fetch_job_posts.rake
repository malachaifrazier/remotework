namespace :periodic do
  desc "Downloads new job posts"
  task :fetch_job_posts => :environment do
    RssIngestionJob.new.perform([Job::Authentic, Job::Github, Job::StackOverflow, Job::WeWorkRemotely])
  end
end
