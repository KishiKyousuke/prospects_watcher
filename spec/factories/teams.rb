FactoryBot.define do
  factory :team do
    name { '広島' }
    formal_name { '広島東洋カープ' }
    ranking { 2 }
    league { :central }
    url_id { 6 }
    english_name { 'carp' }
  end
end
