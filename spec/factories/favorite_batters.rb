FactoryBot.define do
  factory :favorite_batter do
    association :user
    association :batter
  end
end
