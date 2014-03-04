$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "event_logger/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "event_logger"
  s.version     = EventLogger::VERSION
  s.authors     = ["Vadim Lobanov"]
  s.email       = ["vadim@lobanov.pw"]
  s.homepage    = "http://github.com/vlobanov/event_logger"
  s.summary     = "EventLogger is a tool for logging domain events to MongoDB"
  s.description = "EventLogger is a tool for logging domain events to MongoDB"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir.glob("spec/**/*.rb")

  s.add_dependency "rails", "~> 4.0.3"
end
