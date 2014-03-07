EventLogger::Engine.routes.draw do
  match "/filter(/:page)" => "events#index", via: :get, as: :events_filter
  match "/(:page)" => "events#index", via: :get
  root to: "events#index", page: 1
end
