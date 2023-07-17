i=1

until User.count == 10 do
    User.create(email: "usuario#{i}@email.com", password: "123456", "password_confirmation": "123456", photo: Faker::Avatar.unique.image, name: Faker::Name.unique.name)
    i += 1
end

users = User.all

users.each do |user|
    Post.create(title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false),
        when_went: Faker::Date.between(from: 10.years.ago, to: Date.today),
        place: Faker::Address.country,
        user_id: user.id)
end

posts = Post.all
until Comment.count == 100 do
    Comment.create(content: Faker::Lorem.paragraph_by_chars(number: 300, supplemental: false), 
        post_id: posts.sample.id,
        user_id: users.sample.id)
end

kinds = Post::Kinds
until Reaction.count == 200 do

        Reaction.create(post_id: posts.sample.id,
            user_id: users.sample.id,
            kind: kinds.sample)

end