# frozen_string_literal: true

class PlayersDataFormatter
  attr_reader :all_data

  def initialize(teams)
    @teams = teams
  end

  def run
    all_data = { central: [], pacific: [] }
    @teams.each do |team|
      batters = team.batters.select(:id, :number, :name)
      pitchers = team.pitchers.select(:id, :number, :name)
      all_data[team.league.to_sym] << {
        name: team.name,
        formal_name: team.formal_name,
        batters: sort_by_number(batters),
        pitchers: sort_by_number(pitchers)
      }
    end
    all_data
  end

  private
  def sort_by_number(players)
    players.sort_by { |player| player.number.to_i }
  end
end
