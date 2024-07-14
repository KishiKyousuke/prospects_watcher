FactoryBot.define do
  factory :batter do
    number { '1' }
    name { '鈴木 誠也' }
    batting_average { '0.317' }
    home_run { '38' }
    runs_batted_in { '88' }
    stolen_base { '9' }
    on_base_percentage { '0.433' }
    on_base_plus_slugging { '1.072' }
    walks { '87' }
    hit_by_pitch { '6' }
    scoring_position_batting_average { '0.295' }
    strikeout { '88' }
    error { '3' }
    url { 'https://example.com' }
    at_bat { '533' }
    hits { '138' }
    plate_appearance { '435' }
  end
end
