module EventLogger
  class Event
    include ::Mongoid::Document
    include ::Mongoid::Timestamps

    field :event_type, type: String
    field :event_subtype, type: String

  end
end