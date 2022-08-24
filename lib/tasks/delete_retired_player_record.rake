# frozen_string_literal: true

desc 'NPBから引退・移籍した選手を削除する'
task delete_retired_player_record: :environment do
  # 更新が昨年時点で止まっている選手をDBから取り除く
  target_period = (Time.new(Time.current.year - 1, 1)..Time.new(Time.current.year - 1, 12))

  retired_batters = Batter.where(updated_at: target_period)
  retired_pitchers = Pitcher.where(updated_at: target_period)

  # Yahooのデータが新シーズンのものに更新が行われている場合のみ削除を実行
  new_season_player_record =
    Batter.find_by!(updated_at: Time.new(Time.current.year)..) || Pitcher.find_by!(updated_at: Time.new(Time.current.year)..)

  if new_season_player_record.present?
    retired_batters.destroy_all
    retired_pitchers.destroy_all
    puts '引退・移籍選手のデータ削除が完了しました'
  end

rescue ActiveRecord::RecordNotFound => e
  puts e
  puts 'Yahooのデータが新シーズンのものに更新されていないためタスクを中止します'
end
