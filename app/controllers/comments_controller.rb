class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]

  def create
    # current_userはsorceryのメソッド
    # buildはnewのエイリアス(以前は違ったらしい)
    # 慣習としてbuildは関連付けされたモデルからインスタンスを生成する際に使用。
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    # rubyのmergeメソッド。
    # user_idはcurrent_userから取得している。post_idの情報も欲しいので、URLに含まれたparamsから取得してパラメータとする。
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    # updateでuser_idとpost_idの変更されることはないのでここには含まない。
    params.require(:comment).permit(:body)
  end
end
