module EventLogger
  class EventsController < ApplicationController
    layout 'event_logger/event_logger_application'

    def index
      @events = Event.order_by(created_at: "desc")
      if params[:filter_exceptions]
        @events = @events.where(:caught_exception.ne => nil)
      end
      @events = @events.page(params[:page]).per(50)
    end
  end
end