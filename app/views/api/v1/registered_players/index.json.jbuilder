# frozen_string_literal: true

json.batters do
  json.array! @batters do |batter|
    json.extract! batter, :number, :url, :name, :batting_average, :at_bat,
                  :hits, :home_run, :runs_batted_in, :stolen_base, :on_base_percentage, :on_base_plus_slugging,
                  :walks, :hit_by_pitch, :scoring_position_batting_average, :strikeout, :error
    json.batter_id batter.id
    json.team batter.team.name
    json.english_team_name batter.team.english_name
    batter.plate_appearance == '-' ? json.participation_flag(0) : json.participation_flag(1)
  end
end

json.pitchers do
  json.array! @pitchers do |pitcher|
    json.extract! pitcher, :number, :url, :name, :earned_run_average, :win, :lose, :strikeout,
                  :innings_pitched, :pitched, :number_of_save, :hold_point, :strikeouts_per_nine_innings,
                  :base_on_balls, :hit_by_pitch, :strikeout_to_walk_ratio, :walks_and_hits_per_innings_pitched
    json.pitcher_id pitcher.id
    json.team pitcher.team.name
    json.english_team_name pitcher.team.english_name
    pitcher.pitched == '-' ? json.participation_flag(0) : json.participation_flag(1)
  end
end
