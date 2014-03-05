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

   it "has warning_level field" do
    e = EventLogger::Event.create(warning_level: :error)
    EventLogger::Event.last.warning_level.should == :error
  end

  it "has description field" do
    e = EventLogger::Event.create(description: "Wow!")
    EventLogger::Event.last.description.should == "Wow!"
  end

  it "has created_at field" do
    e = EventLogger::Event.create(event_type: :train_coming)
    (Time.now - EventLogger::Event.last.created_at).should be < 2.seconds
  end

  it "has exception relation" do
    e = EventLogger::Event.new(event_type: :train_coming)
    exc = StandardError.new("a message")
    e.caught_exception = EventLogger::CaughtException.new({})
    e.save!
  end

  describe "#to_s formatting by default" do
    let(:event) { EventLogger::Event.create(event_type: :train_coming, description: "well well") }

    it "is not ugly" do
      event.to_s.should_not include("#<EventLogger::Event")
    end

    it "includes event type" do
      event.to_s.should include event.event_type.to_s
    end

    it "includes event description" do
      event.to_s.should include event.description.to_s
    end

    it "works if only event_type is set" do
      EventLogger::Event.create(event_type: :train_coming).to_s.should include "train_coming"
    end
  end

  describe "default attributes" do
    def event_class_with_default_attribute(attr_name, attr_val)
      klass = Class.new(EventLogger::Event)             # class FireStartedToBurn < EventLogger::Event
      klass.class_eval { send(attr_name, attr_val) }    #  event_type "fire_starts_to_burn"
      klass                                             # end
    end

    [:event_type, :warning_level, :description].each do |field|
      it "sets default #{field}" do
        val = SecureRandom.hex(4)
        klass = event_class_with_default_attribute(field, val)
        klass.new().send(field).to_s.should == val
      end

      it "setting default #{field} does not affect other inherited classes" do
        val = SecureRandom.hex(4)
        klass = event_class_with_default_attribute(field, val)
        klass.new().send(field).to_s.should == val
        Class.new(EventLogger::Event).new.send(field).should be_nil
        EventLogger::Event.new.send(field).should be_nil
      end
    end
  end
end