FactoryBot.define do
  factory :favorite_pitcher do
    association :user
    association :pitcher
  end
end
