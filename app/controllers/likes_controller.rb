class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    # ログインユーザーがあるユーザーにいいねされた時、通知をオンにしていればメールが届く
    # UserMailerでmailerに定義したメソッドを呼び出す。withにはキーの値を渡せる。コントローラでいうparamsと同じ要領。
    UserMailer.with(user_from: current_user, user_to: @post.user, post: @post).like_post.deliver_later if current_user.like(@post) && @post.user.notification_on_like?
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
