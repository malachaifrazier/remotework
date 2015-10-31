namespace :periodic do
  desc "Downloads new job posts from Twitter"
  task :fetch_twitter_jobs, [:job_class] => [:environment] do
    job_class = args[:job_class]
    puts "Processing job class #{job_class}"
    TwitterIngestionJob.perform_later([job_class])
  end
end
