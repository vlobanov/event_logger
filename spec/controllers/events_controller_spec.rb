require "spec_helper"

describe EventLogger::EventsController do
  before(:each) { @routes = EventLogger::Engine.routes }

  it "opens successfully" do
    get :index
  end

  it "sets @events" do
    events = events_in_all_combinations

    get :index

    expect(assigns(:events).to_a).to eq(events[:all])
  end

  describe "filtering" do
    it "filters events with exceptions" do
      events = events_in_all_combinations
      get :index, filter_exceptions: :with_exceptions
      expect(assigns(:events).to_a).to eq(events[:with_exceptions])
    end
    
    it "filters events without exceptions" do
      events = events_in_all_combinations
      get :index, filter_exceptions: :without_exceptions
      expect(assigns(:events).to_a).to eq(events[:without_exceptions])
    end
  end

  def events_in_all_combinations
    events = {
      with_exceptions: [
        create(:event_with_exception, created_at: decreasing_created_at),
        create(:event_with_exception, created_at: decreasing_created_at),
        create(:event_full, created_at: decreasing_created_at),
        create(:event_full, created_at: decreasing_created_at)
      ],
      without_exceptions: [
        create(:event, created_at: decreasing_created_at),
        create(:event, created_at: decreasing_created_at)
      ]
    }

    events[:all] = events.values.flatten.sort_by(&:created_at).reverse
    events
  end

  def decreasing_created_at
    @curr_created_at ||= Time.now
    @curr_created_at -= 5.seconds
  end
end