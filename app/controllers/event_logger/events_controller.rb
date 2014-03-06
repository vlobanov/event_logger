module EventLogger
  class EventsController < ApplicationController
    def index
      @events = Event.order_by(created_at: "desc")
      EventLogger::Logger.new.log(:index_page_opened, "hello, world!")
    end
  end
end