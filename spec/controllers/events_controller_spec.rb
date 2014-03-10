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
      get :index, filter_exception: :with_exception
      expect(assigns(:events).to_a).to eq(events[:with_exceptions])
    end

    it "filters events without exceptions" do
      events = events_in_all_combinations
      get :index, filter_exception: :without_exception
      expect(assigns(:events).to_a).to eq(events[:without_exceptions])
    end

    it "filters events by type" do
      events_in_all_combinations
      get :index, filter_type: ["event_with_exception"]
      assigns(:events).to_a.each do |e|
        e.event_type.should == :event_with_exception
      end
    end

    it "filters events by several types" do
      events_in_all_combinations
      
      create(:event, event_type: :blackout)
      create(:event, event_type: :sunrise)
      create(:event, event_type: :sunset)
      create(:event, event_type: :midnight)

      expected_types = [:blackout, :sunset, :midnight]

      get :index, filter_type: expected_types
      
      assigns(:events).to_a.map(&:event_type).should =~ expected_types
    end

    it "filters events by types and exceptions" do
      events_in_all_combinations
      
      create(:event, event_type: :blackout)
      sunrize = create(:event_with_exception, event_type: :sunrise)
      create(:event, event_type: :sunset)
      midnight = create(:event_with_exception, event_type: :midnight)

      expected_types = [:sunrise, :sunset, :midnight]

      get :index, filter_type: expected_types, filter_exception: :with_exception
      
      assigns(:events).to_a.should =~ [sunrize, midnight]
    end

    describe "filtering by time" do
      it "filters by minimum time" do
        recent = create(:event)
        week_old = create(:event, created_at: 7.days.ago)
        from_time = 5.days.ago.to_i

        get :index, filter_time_from: from_time
      
        assigns(:events).to_a.should =~ [recent]
      end

      it "filters by maximum time" do
        recent = create(:event)
        week_old = create(:event, created_at: 7.days.ago)
        to_time = 2.days.ago.to_i

        get :index, filter_time_to: to_time
      
        assigns(:events).to_a.should =~ [week_old]
      end
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