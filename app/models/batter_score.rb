# frozen_string_literal: true

class BatterScore
  def initialize(scores, team_id)
    @number = scores[1]
    @url = scores[2]
    @name = scores[3].strip
    @team_id = team_id
    @batting_average = scores[4]
    @plate_appearance = scores[6]
    @at_bat = scores[7]
    @hits = scores[8]
    @home_run = scores[11]
    @runs_batted_in = scores[13]
    @stolen_base = scores[20]
    @on_base_percentage = scores[23]
    @on_base_plus_slugging = scores[25]
    @walks = scores[16]
    @hit_by_pitch = scores[17]
    @scoring_position_batting_average = scores[26]
    @strikeout = scores[15]
    @error = scores[27]
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
    batter.touch
  end
end
