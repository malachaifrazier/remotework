source 'https://rubygems.org'

ruby "2.2.1"

### Standard Rails Stuff ###

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
# gem 'activerecord-jdbc-adapter'

# for when we were trying JRuby, which isn't working right now. (v_v)
#gem 'activerecord-jdbcpostgresql-adapter'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

### Added for this project ###

gem 'puma'                                          # Multithreaded server
gem 'haml'
gem 'bootstrap-sass'
gem 'jasny-bootstrap-rails'                         # for the responsive side menu
gem 'font-awesome-rails'                            # fontawesome web fonts
gem 'feedjira'                                      # RSS Reader for scrape tasks
gem 'nokogiri'                                      # XML/HTML Scraper
gem "ruby-readability", :require => 'readability'   # Cleans up job description text on Stack Overflow
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
gem 'rails_12factor', group: :production            # for heroku
gem 'newrelic_rpm'                                  # monitoring
gem 'sidekiq'                                       # background job processing.
gem 'capistrano-sidekiq', group: :development       # to deploy sidekiq stuff.
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

# Capistrano stuff
group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
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
