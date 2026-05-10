require 'rails_helper'

RSpec.describe PitcherScore, type: :model do
  let(:team) { create(:team) }

  let(:scores) do
    Array.new(29).tap do |s|
      s[0]  = '18'
      s[1]  = 'https://baseball.yahoo.co.jp/npb/player/5678/top'
      s[2]  = '  前田 健太  '
      s[3]  = '2.09'
      s[4]  = '29'
      s[9]  = '15'
      s[10] = '8'
      s[12] = '0'
      s[13] = '0'
      s[15] = '206.1'
      s[18] = '175'
      s[19] = '7.63'
      s[20] = '41'
      s[21] = '6'
      s[27] = '4.27'
      s[28] = '1.01'
    end
  end

  subject(:pitcher_score) { described_class.new(scores, team.id) }

  describe '#initialize' do
    it '背番号をインデックス0から取得する' do
      expect(pitcher_score.instance_variable_get(:@number)).to eq '18'
    end

    it 'URLをインデックス1から取得する' do
      expect(pitcher_score.instance_variable_get(:@url)).to eq 'https://baseball.yahoo.co.jp/npb/player/5678/top'
    end

    it '選手名の前後の空白を除去する' do
      expect(pitcher_score.instance_variable_get(:@name)).to eq '前田 健太'
    end

    it 'team_idを正しく取得する' do
      expect(pitcher_score.instance_variable_get(:@team_id)).to eq team.id
    end

    it '防御率(earned_run_average)をインデックス3から取得する' do
      expect(pitcher_score.instance_variable_get(:@earned_run_average)).to eq '2.09'
    end

    it '登板数(pitched)をインデックス4から取得する' do
      expect(pitcher_score.instance_variable_get(:@pitched)).to eq '29'
    end

    it '勝利(win)をインデックス9から取得する' do
      expect(pitcher_score.instance_variable_get(:@win)).to eq '15'
    end

    it '敗北(lose)をインデックス10から取得する' do
      expect(pitcher_score.instance_variable_get(:@lose)).to eq '8'
    end

    it 'ホールドポイント(hold_point)をインデックス12から取得する' do
      expect(pitcher_score.instance_variable_get(:@hold_point)).to eq '0'
    end

    it 'セーブ数(number_of_save)をインデックス13から取得する' do
      expect(pitcher_score.instance_variable_get(:@number_of_save)).to eq '0'
    end

    it '投球回(innings_pitched)をインデックス15から取得する' do
      expect(pitcher_score.instance_variable_get(:@innings_pitched)).to eq '206.1'
    end

    it '奪三振(strikeout)をインデックス18から取得する' do
      expect(pitcher_score.instance_variable_get(:@strikeout)).to eq '175'
    end

    it '9回あたり奪三振(strikeouts_per_nine_innings)をインデックス19から取得する' do
      expect(pitcher_score.instance_variable_get(:@strikeouts_per_nine_innings)).to eq '7.63'
    end

    it '与四球(base_on_balls)をインデックス20から取得する' do
      expect(pitcher_score.instance_variable_get(:@base_on_balls)).to eq '41'
    end

    it '与死球(hit_by_pitch)をインデックス21から取得する' do
      expect(pitcher_score.instance_variable_get(:@hit_by_pitch)).to eq '6'
    end

    it '奪三振/与四球(strikeout_to_walk_ratio)をインデックス27から取得する' do
      expect(pitcher_score.instance_variable_get(:@strikeout_to_walk_ratio)).to eq '4.27'
    end

    it 'WHIP(walks_and_hits_per_innings_pitched)をインデックス28から取得する' do
      expect(pitcher_score.instance_variable_get(:@walks_and_hits_per_innings_pitched)).to eq '1.01'
    end
  end

  describe '#reflect_in_db' do
    context '該当URLのPitcherが存在しない場合' do
      it '新規レコードを作成する' do
        expect { pitcher_score.reflect_in_db }.to change(Pitcher, :count).by(1)
      end

      it '正しい属性でレコードを作成する' do
        pitcher_score.reflect_in_db
        pitcher = Pitcher.find_by(url: 'https://baseball.yahoo.co.jp/npb/player/5678/top')
        expect(pitcher).to have_attributes(
          number: '18',
          name: '前田 健太',
          team_id: team.id,
          earned_run_average: '2.09',
          pitched: '29',
          win: '15',
          lose: '8',
          hold_point: '0',
          number_of_save: '0',
          innings_pitched: '206.1',
          strikeout: '175',
          strikeouts_per_nine_innings: '7.63',
          base_on_balls: '41',
          hit_by_pitch: '6',
          strikeout_to_walk_ratio: '4.27',
          walks_and_hits_per_innings_pitched: '1.01'
        )
      end
    end

    context '該当URLのPitcherが既に存在する場合' do
      let!(:existing_pitcher) do
        create(:pitcher, url: 'https://baseball.yahoo.co.jp/npb/player/5678/top', team:, name: '旧名前', win: '0')
      end

      it 'レコードを新規作成せず既存レコードを更新する' do
        expect { pitcher_score.reflect_in_db }.not_to change(Pitcher, :count)
      end

      it '既存レコードの値を上書きする' do
        pitcher_score.reflect_in_db
        expect(existing_pitcher.reload).to have_attributes(
          name: '前田 健太',
          win: '15'
        )
      end

      it 'updated_atを更新する' do
        original_time = 1.day.ago
        existing_pitcher.update_column(:updated_at, original_time)
        pitcher_score.reflect_in_db
        expect(existing_pitcher.reload.updated_at).to be > original_time
      end
    end
  end
end
