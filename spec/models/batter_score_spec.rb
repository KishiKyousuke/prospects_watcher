require 'rails_helper'

RSpec.describe BatterScore, type: :model do
  let(:team) { create(:team) }

  let(:scores) do
    Array.new(28).tap do |s|
      s[1]  = '51'
      s[2]  = 'https://baseball.yahoo.co.jp/npb/player/1234/top'
      s[3]  = '  鈴木 誠也  '
      s[4]  = '0.317'
      s[6]  = '542'
      s[7]  = '435'
      s[8]  = '138'
      s[11] = '38'
      s[13] = '88'
      s[15] = '99'
      s[16] = '87'
      s[17] = '6'
      s[20] = '9'
      s[23] = '0.433'
      s[25] = '1.072'
      s[26] = '0.295'
      s[27] = '3'
    end
  end

  subject(:batter_score) { described_class.new(scores, team.id) }

  describe '#initialize' do
    it '背番号を正しく取得する' do
      expect(batter_score.instance_variable_get(:@number)).to eq '51'
    end

    it 'URLを正しく取得する' do
      expect(batter_score.instance_variable_get(:@url)).to eq 'https://baseball.yahoo.co.jp/npb/player/1234/top'
    end

    it '選手名の前後の空白を除去する' do
      expect(batter_score.instance_variable_get(:@name)).to eq '鈴木 誠也'
    end

    it 'team_idを正しく取得する' do
      expect(batter_score.instance_variable_get(:@team_id)).to eq team.id
    end

    it '打率(batting_average)をインデックス4から取得する' do
      expect(batter_score.instance_variable_get(:@batting_average)).to eq '0.317'
    end

    it '打席数(plate_appearance)をインデックス6から取得する' do
      expect(batter_score.instance_variable_get(:@plate_appearance)).to eq '542'
    end

    it '打数(at_bat)をインデックス7から取得する' do
      expect(batter_score.instance_variable_get(:@at_bat)).to eq '435'
    end

    it '安打数(hits)をインデックス8から取得する' do
      expect(batter_score.instance_variable_get(:@hits)).to eq '138'
    end

    it '本塁打(home_run)をインデックス11から取得する' do
      expect(batter_score.instance_variable_get(:@home_run)).to eq '38'
    end

    it '打点(runs_batted_in)をインデックス13から取得する' do
      expect(batter_score.instance_variable_get(:@runs_batted_in)).to eq '88'
    end

    it '三振(strikeout)をインデックス15から取得する' do
      expect(batter_score.instance_variable_get(:@strikeout)).to eq '99'
    end

    it '四球(walks)をインデックス16から取得する' do
      expect(batter_score.instance_variable_get(:@walks)).to eq '87'
    end

    it '死球(hit_by_pitch)をインデックス17から取得する' do
      expect(batter_score.instance_variable_get(:@hit_by_pitch)).to eq '6'
    end

    it '盗塁(stolen_base)をインデックス20から取得する' do
      expect(batter_score.instance_variable_get(:@stolen_base)).to eq '9'
    end

    it '出塁率(on_base_percentage)をインデックス23から取得する' do
      expect(batter_score.instance_variable_get(:@on_base_percentage)).to eq '0.433'
    end

    it 'OPS(on_base_plus_slugging)をインデックス25から取得する' do
      expect(batter_score.instance_variable_get(:@on_base_plus_slugging)).to eq '1.072'
    end

    it '得点圏打率(scoring_position_batting_average)をインデックス26から取得する' do
      expect(batter_score.instance_variable_get(:@scoring_position_batting_average)).to eq '0.295'
    end

    it 'エラー(error)をインデックス27から取得する' do
      expect(batter_score.instance_variable_get(:@error)).to eq '3'
    end
  end

  describe '#reflect_in_db' do
    context '該当URLのBatterが存在しない場合' do
      it '新規レコードを作成する' do
        expect { batter_score.reflect_in_db }.to change(Batter, :count).by(1)
      end

      it '正しい属性でレコードを作成する' do
        batter_score.reflect_in_db
        batter = Batter.find_by(url: 'https://baseball.yahoo.co.jp/npb/player/1234/top')
        expect(batter).to have_attributes(
          number: '51',
          name: '鈴木 誠也',
          team_id: team.id,
          batting_average: '0.317',
          plate_appearance: '542',
          at_bat: '435',
          hits: '138',
          home_run: '38',
          runs_batted_in: '88',
          strikeout: '99',
          walks: '87',
          hit_by_pitch: '6',
          stolen_base: '9',
          on_base_percentage: '0.433',
          on_base_plus_slugging: '1.072',
          scoring_position_batting_average: '0.295',
          error: '3'
        )
      end
    end

    context '該当URLのBatterが既に存在する場合' do
      let!(:existing_batter) do
        create(:batter, url: 'https://baseball.yahoo.co.jp/npb/player/1234/top', team: team, name: '旧名前', home_run: '0')
      end

      it 'レコードを新規作成せず既存レコードを更新する' do
        expect { batter_score.reflect_in_db }.not_to change(Batter, :count)
      end

      it '既存レコードの値を上書きする' do
        batter_score.reflect_in_db
        expect(existing_batter.reload).to have_attributes(
          name: '鈴木 誠也',
          home_run: '38'
        )
      end

      it 'updated_atを更新する' do
        original_time = 1.day.ago
        existing_batter.update_column(:updated_at, original_time)
        batter_score.reflect_in_db
        expect(existing_batter.reload.updated_at).to be > original_time
      end
    end
  end
end
