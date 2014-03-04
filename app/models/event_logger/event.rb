module EventLogger
  class Event
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :event_type, type: Symbol
    field :event_subtype, type: Symbol
    field :warning_level, type: Symbol
    field :description, type: String

    embeds_one :caught_exception

    def to_s
      ["#{event_type}:#{event_subtype}",
        description].compact.join(" ")
    end
  end
end