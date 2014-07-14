source 'https://rubygems.org'

ruby "2.1.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

group :development, :test do
  # Use sqlite3 as the database for Active Record locally
  gem 'sqlite3',     '~> 1.3.9'
  gem 'rspec-rails', '~> 3.0.1'
  # The following optional lines are part of the advanced setup.
  # gem 'guard-rspec'
  # gem 'spork-rails', '4.0.0'
  # gem 'guard-spork', '1.5.0'
  # gem 'childprocess', '0.3.6'
end

# Bootstrap 3
gem 'bootstrap-sass',     '~> 3.2.0'
gem 'autoprefixer-rails', '~> 2.1.0.20140628'
gem 'font-awesome-sass',  '~> 4.1.0'

# https://github.com/TrevorS/bootstrap3-datetimepicker-rails
gem 'momentjs-rails', '~> 2.5.0'
gem 'bootstrap3-datetimepicker-rails', '~> 3.0.0.2'

# sass-rails: Use SCSS for stylesheets
# Use Uglifier as compressor for JavaScript assets
# Use CoffeeScript for .js.coffee assets and views
gem 'sass-rails',   '~> 4.0.3'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# jbuilder: Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# sdoc: bundle exec rake doc:rails generates the API under doc/api.
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
# bcrypt: Use ActiveModel has_secure_password
gem 'jquery-rails', '~> 3.1.1'
gem 'turbolinks',   '~> 2.2.2'
gem 'jbuilder',     '~> 2.0'
gem 'sdoc',         '~> 0.4.0',  group: :doc
gem 'spring',       '~> 1.1.3',  group: :development
gem 'bcrypt',       '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :test do
  gem 'selenium-webdriver', '~> 2.42.0'
  gem 'capybara',           '~> 2.4.1'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'cucumber-rails',     '1.4.0', :require => false
  gem 'database_cleaner',   :github => 'bmabey/database_cleaner'

  # Uncomment this line on OS X.
  # gem 'growl', '1.0.3'
end

group :production do
  gem 'pg',             '~> 0.17.1'
  gem 'rails_12factor', '~> 0.0.2'
end

gem 'quiet_assets', '~> 1.0.3'  # pithier logging
gem 'devise',       '~> 3.2.4'  # simplified authentication
gem 'simple_form',  '~> 3.1.0rc'
