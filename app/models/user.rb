# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!

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

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }
  
  def own?(object)
    id == object.user_id
  end

  # like,unlike,like?メソッドの追加
  # (post)には @post = Post.find(params[:post_id]) が入る
  def like(post)
    # この << が何かわからず。調べて近いかもと思ったのが collectionメソッド？
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
end
