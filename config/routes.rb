Ppatch::Application.routes.draw do
  
  get "blog"          => "posts#index",       as: :posts
  get "posts/show"    => "posts#show",        as: :post
  get "posts/new"
  post "posts/new"    => "posts#create",      as: :create_post
  
  get "tools/new"
  get "tools/index"
  get "welcome/home"
  
  get "events/new"    => "events#new",        as: :new_event
  get "events"        => "events#index",      as: :events
  post "/events"      => "events#create"

  get "events/:id"         => "events#show",        as: :event
  patch "/events/:id"      => "events#update"
  delete "events/:id"      => "events#destroy"
  get "events/:id/edit"    => "events#edit",        as: :edit_event


  get "users/show"
  get "users/new"

  get "/signout"      => "sessions#destroy",  as: :sign_out
  get "/signin"       => "sessions#create",   as: :sign_in

  get "/auth/twitter/callback", to: "sessions#create"

  root "welcome#home"
end
