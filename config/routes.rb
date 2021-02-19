Rails.application.routes.draw do
  # localhost:3000を開いたとき、usersコントローラのnewアクションを呼び出す。
  root 'users#new'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create] # %記法 => [:new, :create]
  resources :posts
end
