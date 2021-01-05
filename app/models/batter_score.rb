# frozen_string_literal: true

class BatterScore
  def initialize(scores, team_id)
    @number = scores[0]
    @url = scores[1]
    @name = scores[2]
    @team_id = team_id
    @batting_average = scores[3]
    @plate_appearance = scores[5]
    @at_bat = scores[6]
    @hits = scores[7]
    @home_run = scores[10]
    @runs_batted_in = scores[12]
    @stolen_base = scores[19]
    @on_base_percentage = scores[22]
    @on_base_plus_slugging = scores[24]
    @walks = scores[15]
    @hit_by_pitch = scores[16]
    @scoring_position_batting_average = scores[25]
    @strikeout = scores[14]
    @error = scores[26]
  end

  def reflect_in_db
    batter = Batter.find_or_initialize_by(url: @url)
    batter.update!(number: @number,
                  url: @url,
                  name: @name,
                  team_id: @team_id,
                  batting_average: @batting_average,
                  plate_appearance: @plate_appearance,
                  at_bat: @at_bat,
                  hits: @hits,
                  home_run: @home_run,
                  runs_batted_in: @runs_batted_in,
                  stolen_base: @stolen_base,
                  on_base_percentage: @on_base_percentage,
                  on_base_plus_slugging: @on_base_plus_slugging,
                  walks: @walks,
                  hit_by_pitch: @hit_by_pitch,
                  scoring_position_batting_average: @scoring_position_batting_average,
                  strikeout: @strikeout,
                  error: @error)
  end
end
