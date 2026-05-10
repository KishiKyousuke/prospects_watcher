require 'rails_helper'

RSpec.describe 'GET /api/v1/players', type: :request do
  let(:team) { create(:team) }

  describe 'GET /api/v1/players' do
    context 'データが存在しない場合' do
      before { get '/api/v1/players' }

      it '200を返す' do
        expect(response).to have_http_status(:ok)
      end

      it 'central/pacificキーを含むJSONを返す' do
        json = response.parsed_body
        expect(json.keys).to contain_exactly('central', 'pacific')
      end
    end

    context '選手データが存在する場合' do
      before do
        create(:batter, team:, number: '1')
        create(:pitcher, team:, number: '18')
        get '/api/v1/players'
      end

      it '200を返す' do
        expect(response).to have_http_status(:ok)
      end

      it 'チームのリーグに応じたキーにデータが格納される' do
        json = response.parsed_body
        league_key = team.league
        expect(json[league_key].length).to eq 1
      end

      it 'チームデータにname/formal_name/batters/pitchersが含まれる' do
        json = response.parsed_body
        league_key = team.league
        team_data = json[league_key].first
        expect(team_data.keys).to include('name', 'formal_name', 'batters', 'pitchers')
      end

      it '認証なしでアクセスできる' do
        get '/api/v1/players'
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
