require 'rails_helper'

RSpec.describe 'Api::V1::FavoriteBatters', type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, confirmed_at: Time.current) }
  let!(:batter) { create(:batter, team:) }

  describe 'POST /api/v1/favorite_batters' do
    context '認証済みユーザーの場合' do
      before { sign_in user }

      it 'favorite_batterを作成する' do
        expect {
          post '/api/v1/favorite_batters', params: { player_id: batter.id }
        }.to change(FavoriteBatter, :count).by(1)
      end

      it '該当ユーザーのfavorite_batterが作成される' do
        post '/api/v1/favorite_batters', params: { player_id: batter.id }
        expect(user.favorite_batters.find_by(batter_id: batter.id)).to be_present
      end
    end

    context '未認証の場合' do
      it '401を返す' do
        post '/api/v1/favorite_batters', params: { player_id: batter.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'レコードを作成しない' do
        expect {
          post '/api/v1/favorite_batters', params: { player_id: batter.id }
        }.not_to change(FavoriteBatter, :count)
      end
    end
  end

  describe 'DELETE /api/v1/favorite_batters' do
    context '認証済みユーザーの場合' do
      before do
        sign_in user
        create(:favorite_batter, user:, batter:)
      end

      it 'favorite_batterを削除する' do
        expect {
          delete '/api/v1/favorite_batters', params: { player_id: batter.id }
        }.to change(FavoriteBatter, :count).by(-1)
      end
    end

    context '未認証の場合' do
      before { create(:favorite_batter, user:, batter:) }

      it '401を返す' do
        delete '/api/v1/favorite_batters', params: { player_id: batter.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'レコードを削除しない' do
        expect {
          delete '/api/v1/favorite_batters', params: { player_id: batter.id }
        }.not_to change(FavoriteBatter, :count)
      end
    end
  end
end
