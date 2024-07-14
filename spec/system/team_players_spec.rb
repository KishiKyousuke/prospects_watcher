require 'rails_helper'

RSpec.describe '選手一覧画面', type: :system do
  let!(:user) { create(:user, email: 'sakakura@example.com', confirmed_at: Time.zone.now) }

  before do
    InsertMasterData.insert_team_data
    sign_in user
  end

  describe 'チーム一覧の表示' do
    before { visit players_path }

    it 'チーム一覧画面が表示されること' do
      expect(page).to have_content 'チームから探す'
    end

    it 'セリーグのチーム一覧が表示されること' do
      expect(page).to have_content '阪神タイガース'
      expect(page).to have_content '広島東洋カープ'
      expect(page).to have_content '横浜DeNAベイスターズ'
      expect(page).to have_content '読売ジャイアンツ'
      expect(page).to have_content '東京ヤクルトスワローズ'
      expect(page).to have_content '中日ドラゴンズ'
    end

    context 'パリーグのタブに切り替えた時' do
      before do
        find('div.pacific-tab').click
      end

      it 'パリーグのチーム一覧が表示されること' do
        expect(page).to have_content 'オリックス・バファローズ'
        expect(page).to have_content '千葉ロッテマリーンズ'
        expect(page).to have_content '福岡ソフトバンクホークス'
        expect(page).to have_content '東北楽天ゴールデンイーグルス'
        expect(page).to have_content '埼玉西武ライオンズ'
        expect(page).to have_content '北海道日本ハムファイターズ'
      end
    end
  end

  describe '選手一覧の表示' do
    before { visit players_path }
    let!(:team) { Team.find_by(name: '広島') }
    let!(:batter) do
      create(
        :batter,
        name: '田村 俊介',
        team: team,
        number: '60'
      )
    end
    let!(:pitcher) do
      create(
        :pitcher,
        name: '斉藤 優汰',
        team: team,
        number: '47'
      )
    end

    before { visit players_path }

    it 'チームをクリックするとそのチームの選手一覧が表示されること' do
      click_on '広島東洋カープ'
      expect(page).to have_content '野手'
      expect(page).to have_content '背番号'
      expect(page).to have_content '名前'
      expect(page).to have_content '60'
      expect(page).to have_content '田村 俊介'
      expect(page).to have_content '投手'
      expect(page).to have_content '47'
      expect(page).to have_content '斉藤 優汰'
    end

    it '+ボタンを押すと選手が登録されること' do
      click_on '広島東洋カープ'
      first('button.light-green').click
      expect(page).to have_content '登録完了'
      expect(page).to have_content '選手を登録しました'
    end

    context '登録済みの選手の場合' do
      before do
        FavoriteBatter.create!(user: user, batter: batter)
        visit players_path
      end

      it '-ボタンを押すと選手が登録解除されること' do
        click_on '広島東洋カープ'
        first('button.red').click
        expect(page).to have_content '登録解除'
        expect(page).to have_content '選手を登録から解除しました'
      end
    end
  end
end
