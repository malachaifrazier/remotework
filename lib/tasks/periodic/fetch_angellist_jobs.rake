namespace :periodic do
  desc "Downloads new job posts from AngelList"
  task :fetch_angellist_jobs => :environment do
    puts "Processing AngelList jobs"
    AngellistIngestionJob.perform_later
  end
end
