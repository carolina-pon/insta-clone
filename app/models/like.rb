# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  # likeはuserとpostに従属する
  belongs_to :user
  belongs_to :post
  has_one :activity, as: :subject, dependent: :destroy

  # user_idはユニーク制約を付ける 1人のいいねが重複するのを防ぐため
  validates :user_id, uniqueness: { scope: :post_id }

  # いいねボタンを押した時(likeがcreateされた時)通知も作成される
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: post.user, action_type: :liked_to_own_post)
  end
end
