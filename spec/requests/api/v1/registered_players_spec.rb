require 'rails_helper'

RSpec.describe 'GET /api/v1/registered_players', type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, confirmed_at: Time.current) }

  describe 'GET /api/v1/registered_players' do
    context '認証済みユーザーの場合' do
      before { sign_in user }

      context 'お気に入り選手が存在しない場合' do
        before { get '/api/v1/registered_players' }

        it '200を返す' do
          expect(response).to have_http_status(:ok)
        end

        it 'batters/pitchersキーを含むJSONを返す' do
          json = response.parsed_body
          expect(json.keys).to contain_exactly('batters', 'pitchers')
        end

        it 'battersが空配列である' do
          expect(response.parsed_body['batters']).to eq []
        end

        it 'pitchersが空配列である' do
          expect(response.parsed_body['pitchers']).to eq []
        end
      end

      context 'お気に入り選手が存在する場合' do
        let!(:batter) { create(:batter, team:) }
        let!(:pitcher) { create(:pitcher, team:) }
        let!(:favorite_batter) { create(:favorite_batter, user:, batter:) }
        let!(:favorite_pitcher) { create(:favorite_pitcher, user:, pitcher:) }

        before { get '/api/v1/registered_players' }

        it 'battersに登録済み打者が含まれる' do
          batter_names = response.parsed_body['batters'].map { |b| b['name'] }
          expect(batter_names).to include(batter.name)
        end

        it 'pitchersに登録済み投手が含まれる' do
          pitcher_names = response.parsed_body['pitchers'].map { |p| p['name'] }
          expect(pitcher_names).to include(pitcher.name)
        end

        it 'batterデータにbatter_idが含まれる' do
          expect(response.parsed_body['batters'].first['batter_id']).to eq batter.id
        end

        it 'pitcherデータにpitcher_idが含まれる' do
          expect(response.parsed_body['pitchers'].first['pitcher_id']).to eq pitcher.id
        end

        it '他ユーザーのお気に入りは含まれない' do
          other_user = create(:user, email: 'other@example.com', confirmed_at: Time.current)
          other_batter = create(:batter, team:, url: 'https://example.com/other', name: '他の選手')
          create(:favorite_batter, user: other_user, batter: other_batter)

          batter_names = response.parsed_body['batters'].map { |b| b['name'] }
          expect(batter_names).not_to include('他の選手')
        end
      end
    end

    context '未認証の場合' do
      it '401を返す' do
        get '/api/v1/registered_players'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
