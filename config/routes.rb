Ppatch::Application.routes.draw do
  get "posts/index"
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

  get "/auth/twitter/callback", to: "sessions#create"

  root "welcome#home"
end
