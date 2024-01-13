require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end

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
  resources :activities, only: [] do
    # メンバールーティングはidを含む→ /activities/:id/read
    patch :read, on: :member
  end
  # 名前空間でグループ化　/mypage/account/~ というURLが生成される
  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
    resource :notification_setting, only: %i[edit update]
  end
end
