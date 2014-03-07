module EventLogger
  class EventsController < ApplicationController
    layout 'event_logger/event_logger_application'

    def index
      @events = Event.order_by(created_at: "desc")
      @events = filter_exceptions(@events)
      @events = @events.page(params[:page]).per(50)
    end

    private

    def filter_exceptions(events)
      case params[:filter_exceptions]
        when "with_exceptions" then events.where(:caught_exception.ne => nil)
        when "without_exceptions" then events.where(:caught_exception => nil)
        else events
      end
    end
  end
end