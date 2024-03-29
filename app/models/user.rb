# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  notification_on_comment :boolean          default(TRUE)
#  notification_on_follow  :boolean          default(TRUE)
#  notification_on_like    :boolean          default(TRUE)
#  salt                    :string(255)
#  username                :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

  mount_uploader :avatar, AvatarUploader

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy
  # commentsテーブルはuesrs,postsテーブルの中間テーブルになる
  has_many :comments, dependent: :destroy
  # has_many,throughでlikesテーブルを通してpostsテーブルの情報が得られる(多対多の関係)
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  # integer型のためforeign_keyを設定
  # フォローしている人・フォローされている人を取得したいが、参照先はどちらもRelationshipになる
  # class_nameを用いて同じモデルを参照し(自己結合)上記の2通りの関連づけを行い、それぞれのレコードの取得ができるようにする
  # 能動的なフォロー関係＝フォローしている
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  # 受動的なフォロー関係＝フォローされている
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :activities, dependent: :destroy
  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  def own?(object)
    id == object.user_id
  end

  # like,unlike,like?メソッドの追加
  # (post)には @post = Post.find(params[:post_id]) が入る
  def like(post)
    # collection<< メソッド
    like_posts << post
  end

  # (post)には @post = Like.find(params[:id]).post が入る
  def unlike(post)
    like_posts.destroy(post)
  end

  # Range#includes?メソッド。
  # like_postsの中に引数で渡したpostが含まれているか = likeされているか を判定している
  def like?(post)
    like_posts.include?(post)
  end

  def follow(other_user)
    following << other_user
  end

  # deleteだとコールバックがスキップされるため、バリデーションが適用できない
  # destroyだとモデルを介して処理されるため上記の問題を解消できる
  def unfollow(other_user)
    following.destroy(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end
end
