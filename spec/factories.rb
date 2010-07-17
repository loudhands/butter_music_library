Factory.define :track do |t|
  t.title Faker::Lorem.words.to_s
  t.genre "Funk"
  t.grouping "Funky"
  t.composer "J Crane"
  t.comments Faker::Lorem.sentence
  t.mp3 
end