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
require 'support/factory_girl'
require 'support/database_cleaner'

Capybara.javascript_driver = :webkit
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.mock_with :rspec
  config.use_transactional_fixtures = false
  config.use_transactional_examples = false
  # config.include HelperMethods, type: :request
  config.extend ControllerMacros, type: :controller
  config.include Rails.application.routes.url_helpers
end

include Warden::Test::Helpers
Warden.test_mode!
