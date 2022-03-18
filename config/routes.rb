Rails.application.routes.draw do
  root 'posts#index'

  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index new create show] # %記法 => [:new, :create]
  resources :posts, shallow: true do
    # IDを伴わないパスを認識し、posts#searchアクションにルーティングする
    collection do
      get :search
    end
    resources :comments
  end

  # ネストしてないので /likes となる
  # postにネストする形で記述してもいいみたい(どのポストへのいいねなのか分かりやすそう)
  # その場合は /posts/:post_id/likes となる
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
