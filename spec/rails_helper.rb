require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'sidekiq/testing'

# require 'capybara/rspec'
# require 'capybara/poltergeist'
# require 'capybara/email/rspec'
#include RSpec::Mocks::ExampleMethods

# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, js_errors: false, port: 44678 + ENV['TEST_ENV_NUMBER'].to_i)
# end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec.configure do |config|
  Sidekiq::Testing.inline!

  #config.include(HelpersFromAppForRspec)

  config.include FactoryGirl::Syntax::Methods
  # config.include Capybara::DSL

  config.use_transactional_fixtures = false

  config.infer_base_class_for_anonymous_controllers = false

  config.backtrace_exclusion_patterns = [
    /\/lib\d*\/ruby\//,
    /bin\//,
    /gems/,
    /spec\/spec_helper\.rb/,
    /lib\/rspec\/(core|expectations|matchers|mocks)/
  ]

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    # Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i
    # Capybara.javascript_driver = :poltergeist
    # Capybara.asset_host = 'http://localhost'
  end

  config.before(:each) do
    DatabaseCleaner.clean
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

FactoryGirl.definition_file_paths = [
  Rails.root.join('spec/support'),
  Rails.root.join('spec/factories')
]

# Capybara.default_wait_time = 10

