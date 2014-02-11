Ppatch::Application.routes.draw do
  get "blog" => "posts#index", as: :posts
  get "posts/show"
  get "posts/new"
  get "tools/new"
  get "tools/index"
  get "welcome/home"
  get "events/new"
  get "events/index"
  get "events/show"
  get "users/show"
  get "users/new"

  get "/signout" => "sessions#destroy", as: :sign_out
  get "/signin" => "sessions#create", as: :sign_in

  get "/auth/twitter/callback", to: "sessions#create"

  root "welcome#home"
end
