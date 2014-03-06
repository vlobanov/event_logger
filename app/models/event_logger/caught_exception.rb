module EventLogger
  class CaughtException
    include Mongoid::Document
    embedded_in :event, class_name: "EventLogger::Event"

    field :class_name, type: String
    field :message, type: String
    field :backtrace, type: Array

    def initialize(attrs_or_exception = nil)
      if attrs_or_exception.kind_of?(Exception)
        source_exception = attrs_or_exception.dup
        attrs = {
          class_name: source_exception.class.name,
          message: source_exception.message,
          backtrace: source_exception.backtrace
        }
        super(attrs)
      else
        super
      end
    end

    def to_s
      [class_name, message].join(" ")
    end
  end
end