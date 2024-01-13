# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default("unread"), not null
#  subject_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_activities_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_activities_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  include Rails.application.routes.url_helpers
  # ポリモーフィック関連づけ
  belongs_to :subject, polymorphic: true
  belongs_to :user

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  # オブジェクト取得する際、integer(数字)じゃなくて下記の項目名で取得できる
  # https://pikawaka.com/rails/enum
  enum action_type: { commented_to_own_post: 0, liked_to_own_post: 1, followed_me: 2 }
  enum read: { unread: false, read: true }

  # 通知の内容ごとに遷移先をそれぞれ指定してあげる
  def redirect_path
    # to_symメソッド…文字列をシンボルに変換
    case action_type.to_sym
      # 右のようなURLが生成される→ http://localhost:3000/posts/12#comment-1
    when :commented_to_own_post
      # anchorを指定すると、ページ内の特定部分に移動できる
      # 今回の場合だとコメント一覧のページの一番上じゃなくて、該当するコメント部分に遷移する
      post_path(subject.post, anchor: "comment-#{subject.id}")
    when :liked_to_own_post
      post_path(subject.post)
    when :followed_me
      user_path(subject.follower)
    end
  end
end
