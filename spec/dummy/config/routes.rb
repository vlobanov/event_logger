Rails.application.routes.draw do
  get "posts/index", as: :posts
  root to: "posts#index"
  mount_event_logger_at "/event_logger"
end
