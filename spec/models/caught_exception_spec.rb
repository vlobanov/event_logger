require "spec_helper"

describe EventLogger::CaughtException do
  let(:event) { event.create() }
  let(:example_exception) { StandardError.new("hello, pretty") }
  let(:caught_exception) { EventLogger::CaughtException.new(example_exception) }
  it "can be initialized with Exception instance" do
    EventLogger::CaughtException.new(example_exception)
  end

  it "stores Exception class name" do
    caught_exception.class_name.should == "StandardError"
  end

  it "stores Exception message" do
    caught_exception.message.should == "hello, pretty"
  end

  it "stores Exception backtrace" do
    caught_exception.backtrace.should == example_exception.backtrace
  end
end