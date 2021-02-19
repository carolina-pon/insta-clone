puts 'Usersのseedを投稿します ...'

# usernameとemailをジブリキャラにしてみた。
10.times do
  character_name =  Faker::JapaneseMedia::StudioGhibli.unique.character
  user = User.create(
      username: character_name,
      # miketaさんのを参考に、スぺースをドットに置換
      email: "#{character_name.gsub(/[[:space:]]/, '.')}@example.com",
      password: 'password',
      password_confirmation: 'password'
      )
  puts "\"#{user.username}\" を作成しました。"
end