require 'rails_helper'

RSpec.describe '選手一覧画面', type: :system do
  let!(:user) { create(:user, email: 'sakakura@example.com', confirmed_at: Time.zone.now) }

  before do
    InsertMasterData.insert_team_data
    sign_in user
  end

  describe 'チーム一覧の表示' do
    before { visit players_path }

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
end
