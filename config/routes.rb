Rails.application.routes.draw do
  # localhost:3000を開いたとき、postsコントローラのindexアクションを呼び出す。
  root 'posts#index'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create] # %記法 => [:new, :create]
  resources :posts do
    resources :comments, shallow: true
  end
end
