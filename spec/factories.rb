FactoryGirl.define do
  factory :event, class: EventLogger::Event do
    event_type :nice_event
    description "ordinary thing"

    factory :event_with_exception do
      caught_exception EventLogger::CaughtException.new(StandardError.new("a bang"))

      factory :event_full do
        messages ["first msg", "second msg"]
      end
    end
  end
end