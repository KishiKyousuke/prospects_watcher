# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ログインページ', type: :system do
  describe :sign_up do
    before { visit new_user_registration_path }

    it '新規ユーザー作成が行えること' do
      fill_in 'Eメール', with: 'kikuchi@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      click_on 'アカウント登録'
      # ログイン画面に遷移
      # TODO:メールを送った旨のメッセージが出ないため対応する
      expect(page).to have_content 'パスワードを忘れましたか？'
      expect(User.last.email).to eq 'kikuchi@example.com'
    end
  end

  describe :login do
    let!(:user) { create(:user, email: 'tanaka@example.com', confirmed_at: Time.zone.now) }
    before { visit new_user_session_path }

    it 'ログインが行えること' do
      fill_in 'Eメール', with: 'tanaka@example.com'
      fill_in 'パスワード', with: 'password'
      click_on 'ログイン'
      save_screenshot 'hoge.png'
    end
  end

  describe :log_out do
  end
end
