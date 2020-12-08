require 'open-uri'
require 'nokogiri'

PLAYERS_SCORE_URL = { '西武' => 'https://baseball.yahoo.co.jp/npb/teams/7/memberlist?kind=',
                      'ソフトバンク' => 'https://baseball.yahoo.co.jp/npb/teams/12/memberlist?kind=',
                      '楽天' => 'https://baseball.yahoo.co.jp/npb/teams/376/memberlist?kind=',
                      'ロッテ' => 'https://baseball.yahoo.co.jp/npb/teams/9/memberlist?kind=',
                      '日本ハム' => 'https://baseball.yahoo.co.jp/npb/teams/8/memberlist?kind=',
                      'オリックス' => 'https://baseball.yahoo.co.jp/npb/teams/11/memberlist?kind=',
                      '巨人' => 'https://baseball.yahoo.co.jp/npb/teams/1/memberlist?kind=',
                      'DeNA' => 'https://baseball.yahoo.co.jp/npb/teams/3/memberlist?kind=',
                      '阪神' => 'https://baseball.yahoo.co.jp/npb/teams/5/memberlist?kind=',
                      '広島' => 'https://baseball.yahoo.co.jp/npb/teams/6/memberlist?kind=',
                      '中日' => 'https://baseball.yahoo.co.jp/npb/teams/4/memberlist?kind=',
                      'ヤクルト' => 'https://baseball.yahoo.co.jp/npb/teams/2/memberlist?kind=' }.freeze

namespace :scrape do
  desc 'Yahooスポーツから野手の成績を取得'
  task batter_record: :environment do
    batter_score_url = PLAYERS_SCORE_URL.map { |key, value| [key, value + 'b'] }.to_h
    batter_score_url.each do |team, url|
      charset = nil
      html = URI.open(url) do |f|
        charset = f.charset
        f.read
      end

      page = Nokogiri::HTML.parse(html, nil, charset)
      players_score = []
      table = page.css('#js-playerTable')
      table.search('tr').each do |node|
        data = []
        node.search('td').each do |n|
          data << n.text.gsub(/\n/, '').lstrip
        end
        players_score << data unless data.empty?
      end

      players_score.map do |player_score|
        batter = Batter.find_or_initialize_by(name: player_score[1], team: team)
        batter.update(number: player_score[0],
                      name: player_score[1],
                      team: team,
                      batting_average: player_score[2],
                      home_run: player_score[9],
                      runs_batted_in: player_score[11],
                      stolen_base: player_score[18],
                      on_base_percentage: player_score[21],
                      on_base_plus_slugging: player_score[23],
                      walks: player_score[14],
                      hit_by_pitch: player_score[15],
                      scoring_position_batting_average: player_score[24],
                      strikeout: player_score[13],
                      error: player_score[25])
      end
    end
  end

  desc 'Yahooスポーツから投手の成績を取得'
  task pitcher_record: :environment do
    pitcher_score_url = PLAYERS_SCORE_URL.map { |key, value| [key, value + 'p'] }.to_h
    pitcher_score_url.each do |team, url|
      charset = nil
      html = URI.open(url) do |f|
        charset = f.charset
        f.read
      end

      page = Nokogiri::HTML.parse(html, nil, charset)
      players_score = []
      table = page.css('#js-playerTable')
      table.search('tr').each do |node|
        data = []
        node.search('td').each do |n|
          data << n.text.gsub(/\n/, '').lstrip
        end
        players_score << data unless data.empty?
      end

      binding.pry

      players_score.map do |player_score|
        pitcher = Pitcher.find_or_initialize_by(name: player_score[1], team: team)
        pitcher.update(number: player_score[0],
                       name: player_score[1],
                       team: team,
                       earned_run_average: player_score[2],
                       win: player_score[8],
                       lose: player_score[9],
                       strikeout: player_score[17],
                       innings_pitched: player_score[14],
                       pitched: player_score[3],
                       number_of_save: player_score[12],
                       hold_point: player_score[11],
                       strikeouts_per_nine_innings: player_score[18],
                       strikeout_to_walk_ratio: player_score[26],
                       walks_and_hits_per_innings_pitched: player_score[27])
      end
    end
  end
end
