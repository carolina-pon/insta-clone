# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer          not null
#  follower_id :integer          not null
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
class Relationship < ApplicationRecord
  # class_name
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  has_one :activity, as: :subject, dependent: :destroy
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # いいね機能同様、同じ人を何度もフォローするのを防ぐ
  # scopeをつけないと、全ユーザーのうち早い者勝ちで最初の1人しかそのユーザーをフォローできなくなる
  validates :follower_id, uniqueness: { scope: :followed_id }

  # フォローボタンを押した時(relationshipがcreateされた時)通知も作成される
  after_create_commit :create_activities

  private

  def create_activities
    Activity.create(subject: self, user: followed, action_type: :followed_me)
  end
end
