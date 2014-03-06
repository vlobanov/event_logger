FactoryGirl.define do
  factory :event, class: EventLogger::Event do
    event_type :simple_event
    description "ordinary thing"

    factory :event_with_exception do
      caught_exception EventLogger::CaughtException.new(StandardError.new("a bang"))
    end
  end
end