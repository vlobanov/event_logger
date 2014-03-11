module ActionDispatch::Routing
  class Mapper
    def mount_event_logger_at(mount_location)
      scope mount_location do
        match "/filter(/:page)" => "event_logger/events#index", via: :get, as: :events_filter
        match "/(:page)" => "event_logger/events#index", via: :get, as: :event_logger
      end
    end
  end
end