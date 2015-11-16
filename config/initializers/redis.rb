$redis_uri = URI.parse(ENV['RA_REDIS_URL'] || 'redis://127.0.0.1:6380/0')
$redis = Redis.new(
  :host => $redis_uri.host, 
  :port => $redis_uri.port, 
  :password => $redis_uri.password
)
