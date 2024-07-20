# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '登録済み選手一覧', type: :system do
  let!(:user) { create(:user, email: 'takahiro@example.com', confirmed_at: Time.zone.now) }

  before do
    InsertMasterData.insert_team_data
    sign_in user
  end

  shared_context '選手登録済み' do
    let!(:team) { Team.find_by(name: '広島') }

    let!(:batter1) do
      create(
        :batter,
        name: '前田 智徳',
        team: team,
        number: '1',
        at_bat: '504',
        batting_average: '.335',
        home_run: '24',
        runs_batted_in: '80',
      )
    end
    let!(:batter2) do
      create(
        :batter,
        name: '新井 貴浩',
        team: team,
        number: '25',
        at_bat: '541',
        batting_average: '.305',
        home_run: '43',
        runs_batted_in: '94',
      )
    end
    let!(:batter3) do
      create(
        :batter,
        name: '栗原 健太',
        team: team,
        number: '5',
        at_bat: '557',
        batting_average: '.332',
        home_run: '23',
        runs_batted_in: '103',
      )
    end

    let!(:pitcher1) do
      create(
        :pitcher,
        name: '黒田 博樹',
        team: team,
        number: '15',
        innings_pitched: '189.1',
        earned_run_average: '1.85',
        win: '13',
        strikeout: '144',
      )
    end
    let!(:pitcher2) do
      create(
        :pitcher,
        name: 'ルイス',
        team: team,
        number: '11',
        innings_pitched: '178',
        earned_run_average: '2.68',
        win: '15',
        strikeout: '183',
      )
    end
    let!(:pitcher3) do
      create(
        :pitcher,
        name: '野村 祐輔',
        number: '19',
        team: team,
        innings_pitched: '152.2',
        earned_run_average: '2.71',
        win: '16',
        strikeout: '91',
      )
    end

    before do
      user.batters << batter1
      user.batters << batter2
      user.batters << batter3
      user.pitchers << pitcher1
      user.pitchers << pitcher2
      user.pitchers << pitcher3
    end
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
      include_context '選手登録済み'

      it '登録済みの野手が表示されること' do
        expect(page).to have_content '前田 智徳'
        expect(page).to have_content '新井 貴浩'
        expect(page).to have_content '栗原 健太'
      end

      context '投手のタブをクリックした場合' do
        before do
          find('div.v-tab', text: '投手').click
        end

        it '登録済みの投手が表示されること' do
          expect(page).to have_content '黒田 博樹'
          expect(page).to have_content 'ルイス'
          expect(page).to have_content '野村 祐輔'
        end
      end
    end
  end

  describe '登録選手の並び替え' do
    include_context '選手登録済み'

    context '野手の並び替え' do
      before { visit registered_players_path }

      it 'デフォルトでは打数の降順で並んでいること' do
        expect(page).to have_selector 'tbody tr:nth-child(1)', text: '栗原 健太'
        expect(page).to have_selector 'tbody tr:nth-child(2)', text: '新井 貴浩'
        expect(page).to have_selector 'tbody tr:nth-child(3)', text: '前田 智徳'
      end

      context '打率のボタンをクリックした場合' do
        before { click_on '打率' }

        it '打率の降順で並び替えられること' do
          expect(page).to have_selector 'tbody tr:nth-child(1)', text: '前田 智徳'
          expect(page).to have_selector 'tbody tr:nth-child(2)', text: '栗原 健太'
          expect(page).to have_selector 'tbody tr:nth-child(3)', text: '新井 貴浩'
        end

        context '打率のボタンをもう一度クリックした場合' do
          before { click_on '打率' }

          it '打率の昇順で並び替えられること' do
            expect(page).to have_selector 'tbody tr:nth-child(1)', text: '新井 貴浩'
            expect(page).to have_selector 'tbody tr:nth-child(2)', text: '栗原 健太'
            expect(page).to have_selector 'tbody tr:nth-child(3)', text: '前田 智徳'
          end
        end
      end

      context 'HRのボタンをクリックした場合' do
        before { click_on 'HR' }

        it 'HRの降順で並び替えられること' do
          expect(page).to have_selector 'tbody tr:nth-child(1)', text: '新井 貴浩'
          expect(page).to have_selector 'tbody tr:nth-child(2)', text: '前田 智徳'
          expect(page).to have_selector 'tbody tr:nth-child(3)', text: '栗原 健太'
        end
      end

      context '打点のボタンをクリックした場合' do
        before { click_on '打点' }

        it '打点の降順で並び替えられること' do
          expect(page).to have_selector 'tbody tr:nth-child(1)', text: '栗原 健太'
          expect(page).to have_selector 'tbody tr:nth-child(2)', text: '新井 貴浩'
          expect(page).to have_selector 'tbody tr:nth-child(3)', text: '前田 智徳'
        end
      end
    end

    context '投手の並び替え' do
      before do
        visit registered_players_path
        find('div.v-tab', text: '投手').click
      end

      it 'デフォルトでは投球回の降順で並んでいること' do
        expect(page).to have_selector 'tbody tr:nth-child(1)', text: '黒田 博樹'
        expect(page).to have_selector 'tbody tr:nth-child(2)', text: 'ルイス'
        expect(page).to have_selector 'tbody tr:nth-child(3)', text: '野村 祐輔'
      end

      context '防御率のボタンをクリックした場合' do
        before { click_on '防御率' }

        it '防御率の昇順で並び替えられること' do
          expect(page).to have_selector 'tbody tr:nth-child(1)', text: '黒田 博樹'
          expect(page).to have_selector 'tbody tr:nth-child(2)', text: 'ルイス'
          expect(page).to have_selector 'tbody tr:nth-child(3)', text: '野村 祐輔'
        end

        context '防御率のボタンをもう一度クリックした場合' do
          before { click_on '防御率' }

          it '防御率の降順で並び替えられること' do
            expect(page).to have_selector 'tbody tr:nth-child(1)', text: '野村 祐輔'
            expect(page).to have_selector 'tbody tr:nth-child(2)', text: 'ルイス'
            expect(page).to have_selector 'tbody tr:nth-child(3)', text: '黒田 博樹'
          end
        end
      end

      context '勝のボタンをクリックした場合' do
        before { click_on '勝' }

        it '勝利数の降順で並び替えられること' do
          expect(page).to have_selector 'tbody tr:nth-child(1)', text: '野村 祐輔'
          expect(page).to have_selector 'tbody tr:nth-child(2)', text: 'ルイス'
          expect(page).to have_selector 'tbody tr:nth-child(3)', text: '黒田 博樹'
        end
      end
    end
  end

  describe '登録選手の解除' do
    include_context '選手登録済み'

    context 'チェックボックスを1つチェックした時' do
      before do
        visit registered_players_path
        first('tbody tr th input[type="checkbox"]').set(true)
      end

      it '選択中の選手数と、解除するボタンが表示されること' do
        expect(page).to have_content '1 選手を選択中'
        expect(page).to have_button '解除する'
      end

      context '解除するボタンをクリックした時' do
        before { click_on '解除する' }

        it '選手が登録解除されること' do
          expect(page).to have_content '登録解除'
          expect(page).to have_content '選手を登録から解除しました'
          expect(page).not_to have_content '栗原 健太'
        end
      end
    end

    context '最上部のチェックボックスをクリックした時' do
      before do
        visit registered_players_path
        first('thead tr th input[type="checkbox"]').set(true)
      end

      it '全てのチェックボックスがチェックされること' do
        expect(page).to have_content '3 選手を選択中'
        expect(page).to have_button '解除する'
      end

      context '解除するボタンをクリックした時' do
        before { click_on '解除する' }

        it '全ての選手が登録解除されること' do
          expect(page).to have_content '登録解除'
          expect(page).to have_content '選手を登録から解除しました'
          expect(page).not_to have_content '前田 智徳'
          expect(page).not_to have_content '新井 貴浩'
          expect(page).not_to have_content '栗原 健太'
        end
      end
    end
  end

  describe '登録選手の比較' do
    include_context '選手登録済み'

    context 'チェックボックスを1つチェックした時' do
      before do
        visit registered_players_path
        first('tbody tr th input[type="checkbox"]').set(true)
      end

      it '選択中の選手数と、比較するボタンが表示されるが、比較するボタンは非活性であること' do
        expect(page).to have_content '1 選手を選択中'
        expect(page).to have_button '比較する', disabled: true
      end
    end

    context 'チェックボックスを2つチェックした時' do
      before do
        visit registered_players_path
        first('tbody tr th input[type="checkbox"]').set(true)
        all('tbody tr th input[type="checkbox"]').last.set(true)
      end

      it '選択中の選手数と、比較するボタンが表示されること' do
        expect(page).to have_content '2 選手を選択中'
        expect(page).to have_button '比較する'
      end

      context '比較するボタンをクリックした時' do
        before { click_on '比較する' }

        it '選手の比較モーダルが開き、優れている指標が強調されること' do
          within('.v-card.v-sheet.theme--light') do
            expect(page).to have_content '前田 智徳'
            expect(page).to have_content '栗原 健太'
            # 優れている打率だけが強調されていること
            expect(find('tr td.emphasis', text: '.335'))
            expect(find('tr td', text: '.332'))
            # 優れている本塁打だけが強調されていること
            expect(find('tr td.emphasis', text: '24'))
            expect(find('tr td', text: '23'))
            # 優れている打点だけが強調されていること
            expect(find('tr td.emphasis', text: '103'))
            expect(find('tr td', text: '80'))
          end
        end

        context '閉じるボタンを押した場合' do
          before { find('.mdi-close-circle').click }

          it '選手の比較モーダルが閉じること' do
            expect(page).to_not have_selector '.v-card.v-sheet.theme--light'
          end
        end
      end
    end
  end
end
