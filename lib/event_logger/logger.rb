module EventLogger
  class Logger
    def log(event_type, *args)
      caught_exception = nil
      messages = []
      begin
        yield(messages) if block_given?
      rescue Exception => e
        caught_exception = e
        raise e
      ensure
        create_event(event_type, caught_exception, messages, *args)
      end
    end

    private
    
    def create_event(event_type, exception, messages, description = nil)
      event_klass = EventTypesCollection.get_class(event_type)
      event = event_klass.new(event_type: event_type)
      event.description = description if description
      event.messages = normalize_messages(messages)
      event.caught_exception = CaughtException.new(exception) if exception
      event.save!
    end

    def normalize_messages(messages)
      messages.map(&:to_s)
    end
  end
end