Ppatch::Application.routes.draw do
  
  get "/events/new"           => "events#new",        as: :new_event
  get "/events"               => "events#index",      as: :events
  post "/events"              => "events#create"

  get "/events/:id"           => "events#show",       as: :event
  patch "/events/:id"         => "events#update"
  delete "/events/:id"        => "events#destroy"
  get "/events/:id/edit"      => "events#edit",       as: :edit_event

  get "/blog"                 => "posts#index",       as: :posts
  get "/blog/:id"             => "posts#show",        as: :post
  get "/blog/new"             => "posts#new",         as: :new_post
  post "/blog"                => "posts#create",      as: :create_post
  get "/blog/:id/edit"        => "posts#edit",        as: :edit_post
  patch "/blog/:id"           => "posts#update"
  delete "/blog/:id"          => "posts#destroy"

  get "/users/:id"            => "users#show",        as: :user
  get "/users/new"

  get "/signout"              => "sessions#destroy",  as: :sign_out
  
  resources :tools

  get "/auth/twitter/callback", to: "sessions#create"

  root "welcome#home"
end
