require "spec_helper"

describe CustomEvent do
  it "has same collection as Event" do
    CustomEvent.collection_name.should == EventLogger::Event.collection_name
  end

  it "is persisted as normal Event" do
    CustomEvent.create(event_type: :CustomEvent, song_name: "Yesterday")
    EventLogger::Event.last.event_type.should == :CustomEvent
    EventLogger::Event.last.song_name.should == "Yesterday"
  end
end