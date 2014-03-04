class EventLogger::Exception
  include Mongoid::Document
  embedded_in :event
end