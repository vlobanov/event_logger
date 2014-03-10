module EventLogger
  class EventTypesCollection
    def self.add(event_type, event_class)
      (@types ||= {})[event_type] = event_class
    end

    def self.get_class(event_type)
      (@types || {}).fetch(event_type) { EventLogger::Event }
    end

    def self.all_types
      (@types || {}).keys
    end
  end
end