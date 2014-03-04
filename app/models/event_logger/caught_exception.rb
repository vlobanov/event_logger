class EventLogger::CaughtException
  include Mongoid::Document
  embedded_in :event
end