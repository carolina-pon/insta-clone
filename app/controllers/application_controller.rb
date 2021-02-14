class ApplicationController < ActionController::Base
  # フラッシュメッセージのタイプを指定
  add_flash_types :success, :info, :warning, :danger
end
