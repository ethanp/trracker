# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'devise'
require 'devise/test_helpers'
require 'support/devise'

Capybara.javascript_driver = :webkit
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.before(:suite)          { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each)           { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each)           { DatabaseCleaner.start }
  config.after(:each)            { DatabaseCleaner.clean }
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.use_transactional_examples = true
  # config.include HelperMethods, type: :request
  config.extend ControllerMacros, type: :controller
end
