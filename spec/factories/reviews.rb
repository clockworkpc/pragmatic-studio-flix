FactoryBot.define do
  factory :review do
    name { "MyString" }
    stars { 1 }
    comment { "MyText" }
    movie { nil }
  end
end
