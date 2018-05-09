# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
5.times do
  User.create!(provider: Faker::Omniauth.google[:provider], uid: Faker::Omniauth.google[:uid], name: Faker::Name.name, oauth_token: Faker::Omniauth.google[:credentials][:token], oauth_expires_at: Faker::Omniauth.google[:credentials][:expires_at], admin: Faker::Boolean.boolean, mod: Faker::Boolean.boolean)
end

3.times do
  Category.create!(name: Faker::ProgrammingLanguage.unique.name)
end

10.times do
  Question.create!(title: Faker::Simpsons.quote, body: Faker::VForVendetta.speech, user: User.all.sample, category: Category.all.sample, edited: false, deleted: false)
end

25.times do
  Comment.create!(body: Faker::RuPaul.quote, user: User.all.sample, question: Question.all.sample, edited: false, deleted: false, mod_flag: false)
end
