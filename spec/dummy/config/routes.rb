Rails.application.routes.draw do

  mount EventLogger::Engine => "/event_logger"
end
