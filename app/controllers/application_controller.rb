class ApplicationController < ActionController::Base
  # 全てのページ(共通部分)で検索フォームを利用するのでApplicationControllerでセットする
  before_action :set_search_posts_form
  # フラッシュメッセージのタイプを指定
  add_flash_types :success, :info, :warning, :danger

  private
  def not_authenticated
    redirect_to login_path, warning: 'ログインしてください'
  end

  def set_search_posts_form
    @search_form = SearchPostsForm.new(search_post_params)
  end

  def search_post_params
    params.fetch(:q, {}).permit(:body, :comment_body, :username)
  end
end
