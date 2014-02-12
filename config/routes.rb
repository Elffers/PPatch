Ppatch::Application.routes.draw do
  get "blog"              => "posts#index", as: :posts
  get "blog/:id"         => "posts#show", as: :post
  get "blog/new"       => "posts#new", as: :new_post
  post "blog"            => "posts#create", as: :create_post
  get "blog/:id/edit"  => "posts#edit", as: :edit_post
  patch "blog/:id"      => "posts#update"
  delete "blog/:id"     => "posts#delete"


  get "welcome/home"
  get "events/new"
  get "events/index"
  get "events/show"
  get "users/show"
  get "users/new"

  resources :tools

  get "/signout" => "sessions#destroy", as: :sign_out
  get "/signin" => "sessions#create", as: :sign_in

  get "/auth/twitter/callback", to: "sessions#create"

  root "welcome#home"
end
