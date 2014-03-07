EventLogger::Engine.routes.draw do
  match "/(:page)" => "events#index", via: :get
  root to: "events#index", page: 1
end
