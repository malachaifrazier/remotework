source 'https://rubygems.org'

### Standard Rails Stuff ###

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
# gem 'activerecord-jdbc-adapter'

# for when we were trying JRuby, which isn't working right now. (v_v)
#gem 'activerecord-jdbcpostgresql-adapter'
gem 'pg'

gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

### Added for this project ###
gem 'simple_form'
gem 'puma'                                          # Multithreaded server
gem 'haml'
gem 'bootstrap-sass'
gem 'jasny-bootstrap-rails'                         # for the responsive side menu
gem 'font-awesome-rails'                            # fontawesome web fonts
gem 'feedjira'                                      # RSS Reader for scrape tasks
gem 'nokogiri'                                      # XML/HTML Scraper
gem 'ruby-readability', require: 'readability'   # Cleans up job description text on Stack Overflow
gem 'kaminari'                                      # Pagination
gem 'friendly_id'                                   # slugs
gem 'validates_email_format_of'                     # e-mail address validation
gem 'uniquify'                                      # to generate tokens
gem 'bootstrap-typeahead-rails'                     # completion of tag names
gem 'bootbox-rails'                                 # prettier modals.
gem 'twitter'                                       # to tweet the jobs.
gem 'pg_search'                                     # for fulltext search
gem 'exception_notification'                        # emails for exeptions
gem 'open_uri_redirections'                         # security be damned, need to parse twitter data feeds.
gem 'newrelic_rpm'                                  # monitoring
gem 'sidekiq'                                       # background job processing.
gem 'whenever'                                      # for scheduled jobs
gem 'rollbar', '~> 2.5.0'                           # exception reporting
gem 'le'                                            # log aggregation (not working?)
gem 'select2-rails'                                 # for tagging on the new job submission page.
gem 'summernote-rails'                              # for WYSIWYG editing (job descriptions, etc).
gem 'bcrypt'                                        # for has_secure_password
gem 'has_secure_token'                              # Generates validation tokens.
gem 'sinatra'                                       # Needed for the Sidekiq web console.
gem 'aasm'                                          # state machine in the job model.
gem 'sitemap_generator'                             # for sitemaps.
gem 'fog-aws'                                       # to upload sitemaps to s3
gem 'rails_12factor', group: :production            # for heroku

# Capistrano stuff
group :development do
  gem 'spring'
  gem 'capistrano-sidekiq'                          # to deploy sidekiq stuff.
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'letter_opener'
  gem 'annotate'
  gem 'web-console'
  gem 'sextant'
  # gem 'flatfoot',                                   # https://github.com/livingsocial/flatfoot
end

group :development, :test do
  # gem 'faker',                   '~> 1.5'
  gem 'pry-rails',               '~> 0.3.4'
  gem 'binding_of_caller',       '~> 0.7.2'
  gem 'better_errors',           '~> 2.1.1'
end

# Spec stuff
group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec-mocks'
  gem 'rspec-sidekiq'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'launchy'
end
