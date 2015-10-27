namespace :periodic do
  desc "Downloads new job posts"
  task :fetch_job_posts => :environment do
    # Keep StackOverflow at the end... we have a vast majority
    # of jobs sourced from them and if there are any duplicates
    # let's let the smaller sites "win."
    RssIngestionJob.perform_later(['Job::Authentic', 'Job::Github', 'Job::Dribbble', 'Job::WeWorkRemotely', 'Job::StackOverflow'])
    TwitterIngestionJob.perform_later(['Job::Jobspresso'])
  end
end
