class RelationshipsController < ApplicationController
  before_action :require_login, only: %i[create destroy]

  def create
    @user = User.find(params[:followed_id])
    # ログインユーザーがあるユーザーからフォローされた時、通知をオンしていればメールが届く
    UserMailer.with(user_from: current_user, user_to: @user).follow.deliver_later if current_user.follow(@user) && @user.notification_on_follow?
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
  end
end
