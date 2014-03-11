require "spec_helper"

describe ApplicationController do
  describe "::protect_event_logger" do
    specify do
      visit event_logger_path
      ApplicationController.should respond_to :protect_event_logger 
    end
  end
end