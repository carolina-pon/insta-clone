class PostsController < ApplicationController
  # 指定したアクションが実行される前にログインしているユーザーか確認
  # reuire_loginはsorceryのメソッド
  before_action :require_login, only: %i[new create edit update destroy]

  def index
    # includesを使用すると、クエリ回数が最小限で読み込みできる(N+1問題)
    # @posts = Post.all.order(created_at: :desc)と記述すると投稿数分のクエリが発行されてしまう
    @posts = Post.includes(:user).order(created_at: :desc)
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
    @post = Post.find(params[:id])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, success: '投稿を削除しました'
  end

  private

  def post_params
    # images:[]と記述することで、JSON形式でparamsを受け取ることができる
    params.require(:post).permit(:body, images: [])
  end
end
