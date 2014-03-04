require "spec_helper"

describe EventLogger::Event do
  it "is mongoid model" do
    EventLogger::Event.ancestors.should include(Mongoid::Document)
  end

  it "has timestamps" do
    EventLogger::Event.ancestors.should include(Mongoid::Timestamps)
  end

  it "has event_type field" do
    e = EventLogger::Event.create(event_type: :train_coming)
    EventLogger::Event.last.event_type.should == :train_coming
  end

  it "has event_subtype field" do
    e = EventLogger::Event.create(event_subtype: :train_with_supplies)
    EventLogger::Event.last.event_subtype.should == :train_with_supplies
  end

  it "has created_at field" do
    e = EventLogger::Event.create(event_type: :train_coming, event_subtype: :train_with_supplies)
    (Time.now - EventLogger::Event.last.created_at).should be < 2.seconds
  end

  it "has exception relation" do
    e = EventLogger::Event.new(event_type: :train_coming, event_subtype: :train_with_supplies)
    exc = StandardError.new("a message")
    e.exception = EventLogger::Exception.new()
    e.save!
  end
end