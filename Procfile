web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -q high,2 -q low -q default REDIS_PROVIDER=RA_REDIS_URL 
