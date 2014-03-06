module EventLogger
  class EventsController < ApplicationController
    def index
      @events = Event.order_by(created_at: "desc")
    end
  end
end