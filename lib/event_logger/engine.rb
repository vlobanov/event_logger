module EventLogger
  class Engine < ::Rails::Engine
    initializer  "event_logger.define_protect_methods" do
      ActiveSupport.on_load(:action_controller) do
        extend EventLogger::ProtectFilter
      end
    end
  end
end
