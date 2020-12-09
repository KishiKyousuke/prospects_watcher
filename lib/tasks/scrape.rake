TEAMS = { '西武' => 7,
          'ソフトバンク' => 12,
          '楽天' => 376,
          'ロッテ' => 9,
          '日本ハム' => 8,
          'オリックス' => 11,
          '巨人' => 1,
          'DeNA' => 3,
          '阪神' => 5,
          '広島' => 6,
          '中日' => 4,
          'ヤクルト' => 2 }.freeze

namespace :scrape do
  desc 'Yahooスポーツから野手の成績を取得'
  task batter_record: :environment do
    TEAMS.each do |team, number|
      url = "https://baseball.yahoo.co.jp/npb/teams/#{number}/memberlist?kind=b"
      player_scores = ScoreScraper.new(url).scrape
      player_scores.each do |player_score|
        BatterScore.new(player_score, team).reflect_in_db
      end
    end
  end

  desc 'Yahooスポーツから投手の成績を取得'
  task pitcher_record: :environment do
    TEAMS.each do |team, number|
      url = "https://baseball.yahoo.co.jp/npb/teams/#{number}/memberlist?kind=p"
      player_scores = ScoreScraper.new(url).scrape
      player_scores.each do |player_score|
        PitcherScore.new(player_score, team).reflect_in_db
      end
    end
  end
end
