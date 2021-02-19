puts 'Postのseedを投稿します ...'
# Postの詳細文はジブリの作品名にしてみた
User.limit(10).each do |user|
  post = user.posts.create(body: "#{Faker::JapaneseMedia::StudioGhibli.unique.movie}" , remote_images_urls: %w[https://picsum.photos/350/350/?random https://picsum.photos/350/350/?random])
  puts "post#{post.id} を作成しました。"
end