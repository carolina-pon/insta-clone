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

  # ネストしてないので /likes となる
  # postにネストする形で記述してもいいみたい(どのポストへのいいねなのか分かりやすそう)
  # その場合は /posts/:post_id/likes となる
  resources :likes, only: %i[create destroy]
end
