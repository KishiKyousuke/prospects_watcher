# frozen_string_literal: true

class PitcherScore
  def initialize(scores, team_id)
    @number = scores[0]
    @url = scores[1]
    @name = scores[2].strip
    @team_id = team_id
    @earned_run_average = scores[3]
    @win = scores[9]
    @lose = scores[10]
    @strikeout = scores[18]
    @innings_pitched = scores[15]
    @pitched = scores[4]
    @number_of_save = scores[13]
    @hold_point = scores[12]
    @strikeouts_per_nine_innings = scores[19]
    @base_on_balls = scores[20]
    @hit_by_pitch = scores[21]
    @strikeout_to_walk_ratio = scores[27]
    @walks_and_hits_per_innings_pitched = scores[28]
  end

  def reflect_in_db
    pitcher = Pitcher.find_or_initialize_by(url: @url)
    pitcher.update!(number: @number,
                    url: @url,
                    name: @name,
                    team_id: @team_id,
                    earned_run_average: @earned_run_average,
                    win: @win,
                    lose: @lose,
                    strikeout: @strikeout,
                    innings_pitched: @innings_pitched,
                    pitched: @pitched,
                    number_of_save: @number_of_save,
                    hold_point: @hold_point,
                    strikeouts_per_nine_innings: @strikeouts_per_nine_innings,
                    base_on_balls: @base_on_balls,
                    hit_by_pitch: @hit_by_pitch,
                    strikeout_to_walk_ratio: @strikeout_to_walk_ratio,
                    walks_and_hits_per_innings_pitched: @walks_and_hits_per_innings_pitched)
    pitcher.touch
  end
end
