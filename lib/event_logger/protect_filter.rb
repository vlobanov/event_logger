module EventLogger
  module ProtectFilter
    def protect_event_logger(method_name = nil, &block)
      is_event_logger_controller = proc { |c| c.class == EventLogger::EventsController }
      
      if method_name
        before_filter method_name, if: is_event_logger_controller
      elsif block
        before_filter if: is_event_logger_controller, &block
      end
    end
  end
end