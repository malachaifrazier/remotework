namespace :periodic do
  desc "Downloads new job posts"
  task :fetch_rss_jobs, [:job_class] => [:environment] do |t,args|
    job_class = args[:job_class]
    puts "Processing job class #{job_class}"
    RssIngestionJob.perform_later([job_class])
  end
end
