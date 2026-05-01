# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::FavoritePitchers', type: :request do
  let(:team) { create(:team) }
  let(:user) { create(:user, confirmed_at: Time.current) }
  let!(:pitcher) { create(:pitcher, team: team) }

  describe 'POST /api/v1/favorite_pitchers' do
    context '認証済みユーザーの場合' do
      before { sign_in user }

      it 'favorite_pitcherを作成する' do
        expect {
          post '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        }.to change(FavoritePitcher, :count).by(1)
      end

      it '該当ユーザーのfavorite_pitcherが作成される' do
        post '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        expect(user.favorite_pitchers.find_by(pitcher_id: pitcher.id)).to be_present
      end
    end

    context '未認証の場合' do
      it '401を返す' do
        post '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'レコードを作成しない' do
        expect {
          post '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        }.not_to change(FavoritePitcher, :count)
      end
    end
  end

  describe 'DELETE /api/v1/favorite_pitchers' do
    context '認証済みユーザーの場合' do
      before do
        sign_in user
        create(:favorite_pitcher, user: user, pitcher: pitcher)
      end

      it 'favorite_pitcherを削除する' do
        expect {
          delete '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        }.to change(FavoritePitcher, :count).by(-1)
      end
    end

    context '未認証の場合' do
      before { create(:favorite_pitcher, user: user, pitcher: pitcher) }

      it '401を返す' do
        delete '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'レコードを削除しない' do
        expect {
          delete '/api/v1/favorite_pitchers', params: { player_id: pitcher.id }
        }.not_to change(FavoritePitcher, :count)
      end
    end
  end
end
