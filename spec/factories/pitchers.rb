FactoryBot.define do
  factory :pitcher do
    number { '18' }
    name { '前田 健太' }
    earned_run_average { '2.09' }
    win { '15' }
    lose { '8' }
    strikeout { '175' }
    innings_pitched { '206.1' }
    pitched { '29' }
    number_of_save { '0' }
    hold_point { '0' }
    strikeouts_per_nine_innings { '7.63' }
    strikeout_to_walk_ratio { '4.27' }
    walks_and_hits_per_innings_pitched { '1.01' }
    url { 'https://example.com' }
    base_on_balls { '41' }
    hit_by_pitch { '6' }
  end
end
