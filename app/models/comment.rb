# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :activity, as: :subject, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1000 }

  # コールバック…コールバックとは、オブジェクトのライフサイクル期間における特定の瞬間に呼び出されるメソッドのこと
  # オブジェクトの状態が切り替わるタイミング(作成、更新など)の前、または後にロジックをトリガーする
  # 【after_create_commit】は【after_commit　〜省略〜 , on: :create】のエイリアス
  # ここではcommentがcreateされたタイミングでcreate_activities(通知を作成)するためにコールバックを使用している
  # https://railsguides.jp/active_record_callbacks.html#%E3%83%88%E3%83%A9%E3%83%B3%E3%82%B6%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E3%82%B3%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :commented_to_own_post)
  end
end
