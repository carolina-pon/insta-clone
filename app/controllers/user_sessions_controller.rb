class UserSessionsController < ApplicationController
  before_action :check_logged_in, only: %i[new create]
  def new; end

  # loginはsorceryの独自メソッド
  def create
    @user = login(params[:email], params[:password])

    #  redirect_back_or_toというのはsorcery独自のメソッド
    if @user
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  # logoutはsorceryの独自メソッド
  def destroy
    logout
    redirect_to login_path, success: 'ログアウトしました'
  end

  private

  def check_logged_in
    redirect_to posts_path if current_user.present?
  end
end
