# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '登録済み選手一覧', type: :system do
  let!(:user) { create(:user, email: 'takahiro@example.com', confirmed_at: Time.zone.now) }

  before do
    InsertMasterData.insert_team_data
    sign_in user
  end

  describe '選手一覧の表示' do
    before { visit registered_players_path }

    it '選手一覧画面が表示されること' do
      expect(page).to have_content '登録済み選手一覧'
    end

    context '登録済みの選手が存在しない場合' do
      it '選手一覧画面への誘導が表示されること' do
        expect(page).to have_content 'まだ選手が登録されていません'
        expect(page).to have_content '気になる選手を登録して成績をチェックしましょう！'
      end
    end

    context '登録済みの選手が存在する場合' do
      let!(:team) { Team.find_by(name: '広島') }
      let!(:batter1) do
        create(
          :batter,
          name: '前田 智徳',
          team: team,
          number: '1',
        )
      end
      let!(:batter2) do
        create(
          :batter,
          name: '栗原 健太',
          team: team,
          number: '５',
          )
      end

      let!(:pitcher1) do
        create(
          :pitcher,
          name: '黒田 博樹',
          team: team,
          number: '15',
        )
      end

      let!(:pitcher2) do
        create(
          :pitcher,
          name: 'ルイス',
          team: team,
          number: '11',
        )
      end

      before do
        user.batters << batter1
        user.batters << batter2
        user.pitchers << pitcher1
        user.pitchers << pitcher2
      end

      it '登録済みの野手が表示されること' do
        expect(page).to have_content '前田 智徳'
        expect(page).to have_content '栗原 健太'
      end

      context '投手のタブをクリックした場合' do
        before do
          find('div.v-tab', text: '投手').click
        end

        it '登録済みの投手が表示されること' do
          expect(page).to have_content '黒田 博樹'
          expect(page).to have_content 'ルイス'
        end
      end
    end
  end
end
