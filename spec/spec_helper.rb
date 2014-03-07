require 'rubygems'
require 'bundler/setup'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'

require 'event_logger'
require 'securerandom'

require 'capybara/rails'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

require 'factory_girl_rails'
require 'factories'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  #config.include Rails.application.routes.url_helpers
  config.render_views

  config.mock_with :mocha

  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end