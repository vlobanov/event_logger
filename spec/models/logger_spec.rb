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

    it "doesn't have caught_exception if nothing was raised" do
      subject.log(:event, "meatball")
      EventLogger::Event.last.caught_exception.should be_nil
    end

    it "creates event of class, corresponding to the type" do
      (klass = Class.new(EventLogger::Event)).instance_eval do
        event_type :i_woke_up
        description "and want some coffee"
      end
      subject.log(:i_woke_up)
      EventLogger::Event.last.description.should == "and want some coffee"
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

      context "when an exception is raised inside the block" do
        let(:example_exception) { StandardError.new("Boom") }

        it "is re-raised" do
          expect do
            subject.log(:exploded_event) { raise example_exception }
          end.to raise_exception(example_exception.class, example_exception.message)
        end

        describe "event" do
          it "is still logged" do
            expect do
              subject.log(:exploded_event) { raise example_exception }
            end.to raise_exception(example_exception.class)

            EventLogger::Event.last.event_type.should == :exploded_event
          end

          describe "caught exception" do
            it "is persisted" do
              subject.log(:exploded_event) { raise example_exception } rescue :dont_care
              EventLogger::Event.last.caught_exception.should_not be_nil
            end

            it "has correct message field value" do
              subject.log(:exploded_event) { raise example_exception } rescue :dont_care
              EventLogger::Event.last.caught_exception.message.should == example_exception.message
            end

            it "has correct class_name field value" do
              AmazingException = Class.new(StandardError)
              subject.log(:exploded_event) { raise AmazingException } rescue :dont_care
              EventLogger::Event.last.caught_exception.class_name.should == "AmazingException"
            end

            it "has correct backtrace field value" do
              subject.log(:exploded_event) { raise example_exception } rescue :dont_care
              EventLogger::Event.last.caught_exception.backtrace.detect{|f| f[__FILE__]}.should_not be_nil
            end
          end
        end
      end
    end
  end
end