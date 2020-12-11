class PlayersDataFormatter
  AFFILIATION_TEAMS = %w[西武 ソフトバンク 楽天 ロッテ 日本ハム オリックス 巨人 DeNA 阪神 広島 中日 ヤクルト]
  attr_reader :all_data

  def initialize(batters, pitchers)
    @batters = batters
    @pitchers = pitchers
    @all_data = {}
  end

  def run
    AFFILIATION_TEAMS.each do |team|
      affiliation_batters = divide_players_into_teams(@batters, team)
      affiliation_pitchers = divide_players_into_teams(@pitchers, team)
      @all_data[team] = {
        batters: sort_by_number(affiliation_batters),
        pitchers: sort_by_number(affiliation_pitchers)
      }
    end
  end

  private

  def divide_players_into_teams(players, team)
    players.select { |player| player.team == team }
  end

  def sort_by_number(players)
    players.sort_by{ |player| player.number.to_i }
  end
end