require "spec_helper"

describe ApplicationController do
  describe "::protect_event_logger" do
    specify do
      visit event_logger_path
      ApplicationController.should respond_to :protect_event_logger 
    end

    it "adds before filters as blocks" do
      hints = 5
      expect do
        hints.times{ visit event_logger_path }
      end.to change{ $before_filter_block_counter || 0 }.by(hints)
    end

    it "adds before filters as methods" do
      hints = 5
      expect do
        hints.times{ visit event_logger_path }
      end.to change{ $before_filter_method_counter || 0 }.by(hints)
    end

    it "does not add before filters to application controllers" do
      hints = 5
      expect do
        hints.times{ visit posts_path }
      end.not_to change{ $before_filter_method_counter || 0 }
    end
  end
end