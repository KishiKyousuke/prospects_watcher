# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersDataFormatter, type: :model do
  let(:central_team) { create(:team, name: '広島', formal_name: '広島東洋カープ', english_name: 'carp', league: :central) }
  let(:pacific_team) { create(:team, name: '福岡', formal_name: '福岡ソフトバンクホークス', english_name: 'hawks', league: :pacific, url_id: 1, ranking: 1) }

  describe '#run' do
    context 'チームが1つも存在しない場合' do
      subject(:result) { described_class.new([], [], []).run }

      it 'central/pacificキーを持つハッシュを返す' do
        expect(result).to eq({ central: [], pacific: [] })
      end
    end

    context 'セ・リーグのチームのみ存在する場合' do
      let!(:batter) { create(:batter, team: central_team, number: '1') }
      let!(:pitcher) { create(:pitcher, team: central_team, number: '18') }

      subject(:result) do
        described_class.new([central_team], Batter.all, Pitcher.all).run
      end

      it 'centralキーにチーム情報を格納する' do
        expect(result[:central].length).to eq 1
      end

      it 'pacificキーは空配列のまま' do
        expect(result[:pacific]).to be_empty
      end

      it 'チームの名称情報が含まれる' do
        team_data = result[:central].first
        expect(team_data).to include(
          name: '広島',
          formal_name: '広島東洋カープ',
          english_team_name: 'carp'
        )
      end

      it 'battersキーに該当チームの打者が含まれる' do
        expect(result[:central].first[:batters]).to include(batter)
      end

      it 'pitchersキーに該当チームの投手が含まれる' do
        expect(result[:central].first[:pitchers]).to include(pitcher)
      end
    end

    context 'セ・リーグとパ・リーグのチームが混在する場合' do
      let!(:central_batter) { create(:batter, team: central_team, number: '1') }
      let!(:pacific_batter) { create(:batter, team: pacific_team, number: '3', url: 'https://pacific.example.com') }

      subject(:result) do
        described_class.new([central_team, pacific_team], Batter.all, Pitcher.all).run
      end

      it 'centralキーにセ・リーグのチームのみ格納する' do
        expect(result[:central].map { |t| t[:name] }).to contain_exactly('広島')
      end

      it 'pacificキーにパ・リーグのチームのみ格納する' do
        expect(result[:pacific].map { |t| t[:name] }).to contain_exactly('福岡')
      end

      it 'セ・リーグの打者はセ・リーグのチームにのみ含まれる' do
        expect(result[:central].first[:batters]).to include(central_batter)
        expect(result[:pacific].first[:batters]).not_to include(central_batter)
      end

      it 'パ・リーグの打者はパ・リーグのチームにのみ含まれる' do
        expect(result[:pacific].first[:batters]).to include(pacific_batter)
        expect(result[:central].first[:batters]).not_to include(pacific_batter)
      end
    end
  end

  describe '#sort_by_number (private)' do
    subject(:formatter) { described_class.new([], [], []) }

    def players_with_numbers(*numbers)
      numbers.map do |num|
        create(:batter, team: central_team, number: num, url: "https://example.com/#{num}")
      end
    end

    it '通常の背番号を数値順にソートする' do
      players = players_with_numbers('10', '1', '50', '3')
      sorted = formatter.send(:sort_by_number, players)
      expect(sorted.map(&:number)).to eq %w[1 3 10 50]
    end

    it '3桁の通常番号(100以上)を正しくソートする' do
      players = players_with_numbers('120', '3', '100')
      sorted = formatter.send(:sort_by_number, players)
      expect(sorted.map(&:number)).to eq %w[3 100 120]
    end

    context '先頭が0の3桁番号（例: 001, 010）の特殊ソート' do
      it '001は101として扱い、100番台の中にソートされる' do
        players = players_with_numbers('99', '001', '100')
        sorted = formatter.send(:sort_by_number, players)
        expect(sorted.map(&:number)).to eq %w[99 100 001]
      end

      it '010は110として扱い、100番台の中にソートされる' do
        players = players_with_numbers('99', '010', '105')
        sorted = formatter.send(:sort_by_number, players)
        expect(sorted.map(&:number)).to eq %w[99 105 010]
      end

      it '001と010が混在する場合、001(→101)が010(→110)より前にソートされる' do
        players = players_with_numbers('010', '001')
        sorted = formatter.send(:sort_by_number, players)
        expect(sorted.map(&:number)).to eq %w[001 010]
      end
    end

    it '選手が0人の場合、空配列を返す' do
      expect(formatter.send(:sort_by_number, [])).to eq []
    end
  end

  describe '#divide_by_team (private)' do
    subject(:formatter) { described_class.new([], [], []) }

    let!(:central_batter1) { create(:batter, team: central_team, number: '1', url: 'https://example.com/1') }
    let!(:central_batter2) { create(:batter, team: central_team, number: '2', url: 'https://example.com/2') }
    let!(:pacific_batter)  { create(:batter, team: pacific_team,  number: '3', url: 'https://example.com/3') }

    it '指定チームの選手のみを返す' do
      result = formatter.send(:divide_by_team, Batter.all, central_team)
      expect(result).to contain_exactly(central_batter1, central_batter2)
    end

    it '他チームの選手は含まれない' do
      result = formatter.send(:divide_by_team, Batter.all, central_team)
      expect(result).not_to include(pacific_batter)
    end

    it '該当チームの選手が存在しない場合、空配列を返す' do
      other_team = create(:team, name: '他球団', formal_name: '他球団', english_name: 'other', league: :central, url_id: 99, ranking: 6)
      result = formatter.send(:divide_by_team, Batter.all, other_team)
      expect(result).to be_empty
    end
  end
end
