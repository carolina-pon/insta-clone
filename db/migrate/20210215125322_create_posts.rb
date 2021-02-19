class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      # 画像追加
      t.string :images, null: false
      # 投稿詳細文
      t.text :body, null: false
      # 外部キー付与
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
