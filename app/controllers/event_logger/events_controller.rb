module EventLogger
  class EventsController < ApplicationController
    layout 'event_logger/even_logger_application'

    def index
      @events = Event.order_by(created_at: "desc")
    end
  end
end