# frozen_string_literal: true

namespace :scrape do
  desc '選手成績を取得'
  task player_record: :environment do
    Rake::Task['scrape:batter_record'].invoke
    Rake::Task['scrape:pitcher_record'].invoke
    ScrapingLog.create!(result: 'success')
  rescue => e
    puts e
    ScrapingLog.create!(result: e)
  end

  desc 'Yahooスポーツから野手の成績を取得'
  task batter_record: :environment do
    Team.all.each do |team|
      url = "https://baseball.yahoo.co.jp/npb/teams/#{team.url_id}/memberlist?kind=b"
      player_scores = ScoreScraper.new(url).scrape
      player_scores.each do |player_score|
        BatterScore.new(player_score, team.id).reflect_in_db
      end
    end
  end

  desc 'Yahooスポーツから投手の成績を取得'
  task pitcher_record: :environment do
    Team.all.each do |team|
      url = "https://baseball.yahoo.co.jp/npb/teams/#{team.url_id}/memberlist?kind=p"
      player_scores = ScoreScraper.new(url).scrape
      player_scores.each do |player_score|
        PitcherScore.new(player_score, team.id).reflect_in_db
      end
    end
  end
end
