web: bundle exec puma -t 5:5 -p ${PORT:-5000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq
redis: bundle exec redis-server --port $RA_REDIS_PORT
