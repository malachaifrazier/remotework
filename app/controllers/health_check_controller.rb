class HealthCheckController < ActionController::Base
  newrelic_ignore
  newrelic_ignore_apdex
  newrelic_ignore_enduser

  def index
    db_version = ActiveRecord::Migrator.current_version
    render json: { version: "#{db_version} #{$redis.ping}" }
  end
end
