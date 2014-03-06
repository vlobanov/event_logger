module EventLogger
  class Event
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :event_type, type: Symbol, default: ->{ defaults[:event_type] }
    field :warning_level, type: Symbol, default: ->{ defaults[:warning_level] }
    field :description, type: String, default: ->{ defaults[:description] }
    field :messages, type: Array, default: []

    embeds_one :caught_exception, class_name: "EventLogger::CaughtException"

    def to_s
      ["#{event_type}",
        description].delete_if(&:blank?).join(" ")
    end

    def self.event_type(val)
      @defaults ||= {}
      @defaults[:event_type] = val
      EventTypesCollection.add(val, self)
    end

    [:warning_level, :description].each do |f|
      Event.singleton_class.instance_eval do
        self.send(:define_method, f) do |val|
          (@defaults ||= {})[f] = val 
        end
      end
    end

    private

    def defaults
      self.class.instance_variable_get("@defaults") || {}
    end
  end
end