module EventLogger
  class EventsController < ::ApplicationController
    layout 'event_logger/event_logger_application'

    FilterParameters = Struct.new(:exception, :event_types, :time_from, :time_to)

    def index
      @events = Event.order_by(created_at: "desc")
      @filters = filter_parameters
      @event_types = EventLogger::Event.distinct(:event_type)
      filter_exceptions!
      filter_types!
      filter_time_from!
      @total_found = @events.count
      @events = @events.page(params[:page]).per(50)
    end

    private

    def filter_parameters
      filters = FilterParameters.new

      if ["with_exception", "without_exception"].include? params[:filter_exception]
        filters.exception = params[:filter_exception].to_sym
      end

      if params[:filter_type].kind_of?(Array)
        filters.event_types =  params[:filter_type]
      end

      filters.time_from = read_datetime(params[:filter_time_from])
      filters.time_to = read_datetime(params[:filter_time_to])      

      filters
    end

    def filter_exceptions!
      @events = case @filters.exception
        when :with_exception then @events.where(:caught_exception.ne => nil)
        when :without_exception then @events.where(:caught_exception => nil)
        else @events
      end
    end

    def filter_types!
      if @filters.event_types
        @events = @events.any_in(event_type: @filters.event_types)
      end
    end

    def filter_time_from!
      if @filters.time_from
        @events = @events.where(:created_at.gte => @filters.time_from)
      end

      if @filters.time_to
        @events = @events.where(:created_at.lte => @filters.time_to)
      end
    end

    def read_datetime(dt_str)
      DateTime.strptime(dt_str, "%s") if dt_str =~ /^(\d+)$/
    end
  end
end