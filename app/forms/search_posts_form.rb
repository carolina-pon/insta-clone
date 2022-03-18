class SearchPostsForm
  # ActiveModelのModelとAttibutesをインクルード
  # FormObjectを使用するための作法
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :body, :string
  attribute :comment_body, :string
  attribute :username, :string

  def search
    # #1でレコードの重複を除く
    scope = Post.distinct # 1
    # #2~#4のフォーム内に入力があればscopeに代入
    scope = splited_bodies.map { |splited_body| scope.body_contain(splited_body) }.inject { |result, scp| result.or(scp) } if body.present? # 2
    #=>発行されたSQL SELECT COUNT(DISTINCT `posts`.`id`) FROM `posts` WHERE ((posts.body LIKE '%風%') OR (posts.body LIKE '%の%'))
    scope = scope.comment_body_contain(comment_body) if comment_body.present? # 3
    scope = scope.username_contain(username) if username.present? # 4
    # #2~#4の後置ifの結果がnilの場合は、直前に代入したものがscopeの値となり、最終的に代入された内容が#5の値となる
    # #5を記述することで、#4の段階でnilだった場合に、最終的にscopeの値ではなく後置ifの結果の「nil」が返ってしまうことを防ぐ
    scope # 5
  end

  private

  # stripメソッドで先頭と末尾の空白を取り除き、splitメソッドで空白ごとに分割して配列にする
  # splitメソッドに対し区切り文字を引数で渡している。引数渡さないとデフォで半角スペース区切り
  # e.g.　"a b c" => ["a", "b", "c"]
  def splited_bodies
    body.strip.split(/[[:blank:]]+/)
  end
end
