FactoryBot.define do
  factory :review do
    user_id { nil }
    stars { (1..5).to_a.sample }
    comment { Faker::Movie.quote }
    movie { nil }
  end
end
