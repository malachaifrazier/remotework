namespace :periodic do
  desc "Downloads new job posts"
  task :fetch_job_posts => :environment do
    RssIngestionJob.perform_later(['Job::Authentic', 'Job::Github', 'Job::StackOverflow', 'Job::WeWorkRemotely'])
    TwitterIngestionJob.perform_later(['Job::Jobspresso'])
  end
end
