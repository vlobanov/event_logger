require "spec_helper"

describe EventLogger::Logger do
  describe "#log" do
    it "takes event_type as first argument" do
      subject.log(:event)
    end

    it "takes event description as second argument" do
      subject.log(:event, "meatball")
      EventLogger::Event.last.description.should == "meatball"
    end

    it "creates EventLogger::Event with given event type" do
      subject.log(:something_weird)
      EventLogger::Event.last.event_type.should == :something_weird
    end

    context "when a block is given" do
      it "is executed" do
        expect { |probe| subject.log(:event, &probe) }.to yield_control
      end

      it "is executed before event is logged" do
        events_count = nil
        subject.log(:event) { events_count = EventLogger::Event.count }
        (EventLogger::Event.count - events_count).should be == 1
      end
    end

    describe "exception handling" do

    end
  end
end