Factory.define :track do |t|
  t.title Faker::Lorem.words.to_s
  t.genre "Funk"
  t.grouping "Funky"
  t.composer "J Crane"
  t.comments Faker::Lorem.sentence
  t.mp3 
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email_confirmed { true }
end