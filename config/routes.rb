Ppatch::Application.routes.draw do

  get "/events/new"           => "events#new",        as: :new_event
  # get "/events"               => "events#index",      as: :events
  post "/events"              => "events#create"

  get "/events/:id"           => "events#show",       as: :event
  patch "/events/:id"         => "events#update"
  delete "/events/:id"        => "events#destroy"
  get "/events/:id/edit"      => "events#edit",       as: :edit_event
  get "/events/:id/rsvp"      => "events#rsvp",       as: :rsvp
  get "/events/:id/flake"     => "events#flake",     as: :flake


  get "/blog"                 => "posts#index",       as: :posts
  get "/blog/new"             => "posts#new",         as: :new_post
  get "/blog/:id"             => "posts#show",        as: :post
  post "/blog"                => "posts#create",      as: :create_post
  get "/blog/:id/edit"        => "posts#edit",        as: :edit_post
  patch "/blog/:id"           => "posts#update"
  delete "/blog/:id"          => "posts#destroy"

  get "/users/:id"            => "users#show",        as: :user
  get "/users/new"
  get "/users/:id/preferences" => "users#preferences", as: :user_preferences

  get "/signout"              => "sessions#destroy",  as: :sign_out

  resources :tools

  get '/tools/:id/borrow'   => "tools#borrow",        as: :borrow_tool
  get '/tools/:id/return'   => "tools#return",        as: :return_tool


  get "/auth/twitter/callback", to: "sessions#create"

  root "welcome#home"
end
