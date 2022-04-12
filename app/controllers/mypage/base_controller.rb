class Mypage::BaseController < ApplicationController
  before_action :require_login
  # 下記のlayout宣言によってMyBase:BaseControllerのレンダリングで
  # app/views/layouts/mypage.html.slimがレイアウトに使われるように上書きしている
  layout 'mypage'
end
