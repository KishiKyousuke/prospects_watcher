# frozen_string_literal: true

class PlayersDataFormatter
  def initialize(teams, batters, pitchers)
    @teams = teams
    @batters = batters
    @pitchers = pitchers
  end

  def run
    @teams.each_with_object({ central: [], pacific: [] }) do |team, hash|
      team_batters = divide_by_team(@batters, team)
      team_pitchers = divide_by_team(@pitchers, team)
      hash[team.league.to_sym] << {
        name: team.name,
        formal_name: team.formal_name,
        batters: sort_by_number(team_batters),
        pitchers: sort_by_number(team_pitchers)
      }
    end
  end

  private
  def sort_by_number(players)
    players.sort_by { |player| player.number.to_i }
  end

  def divide_by_team(players, team)
    players.filter { |player| player.team_id == team.id }
  end
end
