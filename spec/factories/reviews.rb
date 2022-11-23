FactoryBot.define do
  factory :review do
    name { Faker::Movie.title }
    stars { (1..5).to_a.sample }
    comment { Faker::Movie.quote }
    movie { nil }
  end
end
