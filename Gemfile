source 'https://rubygems.org'

ruby "2.2.2"

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
# Removed, doesn't work w/ JRuby.
# gem 'spring',        group: :development

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
gem 'rspec'
gem 'haml'
gem 'bootstrap-sass'
gem 'jasny-bootstrap-rails'                         # for the responsive side menu
gem 'font-awesome-rails'                            # fontawesome web fonts
gem 'feedjira'                                      # RSS Reader for scrape tasks
gem 'nokogiri'                                      # XML/HTML Scraper
gem "ruby-readability", :require => 'readability'   # Cleans up job description text on Stack Overflow
gem 'kaminari'                                      # Pagination
gem 'friendly_id'                                   # slugs
gem 'acts-as-taggable-on'                           # tags... this one kinda sucks actually. :(
gem 'validates_email_format_of'                     # e-mail address validation
gem 'uniquify'                                      # to generate tokens
gem 'bootstrap-typeahead-rails'                     # completion of tag names
gem 'bootbox-rails'                                 # prettier modals.