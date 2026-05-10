require 'rails_helper'

RSpec.describe '未ログイン時のアクセス制御', type: :system do
  context '未ログインで登録済み選手一覧にアクセスした場合' do
    before { visit registered_players_path }

    it 'ログイン画面にリダイレクトされること' do
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content 'パスワードを忘れましたか？'
    end
  end

  context '未ログインで選手検索画面にアクセスした場合' do
    before { visit players_path }

    it 'ログイン画面にリダイレクトされること' do
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content 'パスワードを忘れましたか？'
    end
  end
end
