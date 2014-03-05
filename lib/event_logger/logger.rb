module EventLogger
  class Logger
    def log(event_type, description = nil)
      yield if block_given?
      Event.create(event_type: event_type, description: description)
    end
  end
end