class PostsController < ApplicationController
  # 指定したアクションが実行される前にログインしているユーザーか確認
  # reuire_loginはsorceryのメソッド
  before_action :require_login, only: %i[new create edit update destroy]

  def index
    # includesを使用すると、クエリ回数が最小限で読み込みできる(N+1問題)
    # @posts = Post.all.order(created_at: :desc)と記述すると投稿数分のクエリが発行されてしまう
    # params[:page] にページの数値が入る
    # => 2ページ目の時 localhost:3000/posts?page=2
    @posts = if current_user
               # current_userがフォローしているユーザーの投稿を取ってくる
               current_user.feed.includes(:user).page(params[:page])
             else
               # ログインしていなければ全てのユーザーの投稿を取ってくる
               Post.all.includes(:user).page(params[:page])
             end
    # 最新ユーザーを5人分表示
    @users = User.recent(5)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, success: '投稿しました'
    else
      flash.now[:danger] = '投稿に失敗しました'
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, success: '投稿を更新しました'
    else
      flash.now[:danger] = '投稿の更新に失敗しました'
      render :edit
    end
  end

  def show
    # 投稿詳細ページでcommentの情報も取得したいので
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました'
  end

  def search
    @posts = @search_form.search.includes(:user).page(params[:page])
  end

  private

  def post_params
    # images:[]と記述することで、JSON形式でparamsを受け取ることができる
    params.require(:post).permit(:body, images: [])
  end
end
