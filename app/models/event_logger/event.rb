module EventLogger
  class Event
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :event_type, type: Symbol
    field :event_subtype, type: Symbol
    field :warning_level, type: String

    embeds_one :caught_exception
  end
end