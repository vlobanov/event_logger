module EventLogger
  class Logger
    def log(event_type, *args)
      caught_exception = nil
      begin
        yield if block_given?
      rescue Exception => e
        caught_exception = e
        raise e
      ensure
        create_event(event_type, caught_exception, *args)
      end
    end

    private
    
    def create_event(event_type, exception, description = nil)
      event = Event.new(event_type: event_type, description: description)
      event.caught_exception = CaughtException.new(exception) if exception
      event.save!
    end
  end
end