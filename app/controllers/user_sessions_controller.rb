class UserSessionsController < ApplicationController
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
    redirect_to root_path, success: 'ログアウトしました'
  end
end
