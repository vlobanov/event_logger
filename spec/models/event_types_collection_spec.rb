require "spec_helper"

describe EventLogger::EventTypesCollection do
  let(:simple_inherited_event_class) { Class.new(EventLogger::Event) }

  it "adds event types by name and event class" do
    EventLogger::EventTypesCollection.add(:some_event, simple_inherited_event_class)
  end

  it "returns event class by event type name" do
    EventLogger::EventTypesCollection.add(:some_event, simple_inherited_event_class)
    EventLogger::EventTypesCollection.get_class(:some_event).should == simple_inherited_event_class
  end

  it "returns EventLogger::Event if event_type is unknown" do
    EventLogger::EventTypesCollection.get_class(:hey_joe).should == EventLogger::Event
  end
end