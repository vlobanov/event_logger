Rails.application.routes.draw do

  get "posts/index", as: :posts
  mount EventLogger::Engine => "/event_logger"
end
