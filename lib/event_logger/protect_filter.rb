module EventLogger
  module ProtectFilter
    def protect_event_logger(method_name = nil, &block)
      EventLogger::EventsController.class_eval do
        if method_name
          before_filter(method_name)
        elsif block
          before_filter(&block)
        end
      end
    end
  end
end