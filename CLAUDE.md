# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 進行中の長期計画

Rails アップグレード（6.0 → 8.0）と Vue → React 移行を段階的に進行中。
詳細・現在のフェーズは [`docs/rails_react_migration_plan.md`](docs/rails_react_migration_plan.md) を参照。
このアップグレード関連の作業に着手する前に必ず該当ドキュメントを読むこと。

## Commands

```bash
# 開発サーバー起動
bundle exec rails s

# テスト実行
bundle exec rspec
bundle exec rspec spec/system/registered_players_spec.rb  # 単一ファイル

# Lint
bundle exec rubocop

# DB操作
bin/rails db:prepare   # 作成 + マイグレーション
bin/rails db:migrate

# スクレイピング
rake scrape:player_record     # 全選手データ取得
rake scrape:batter_record     # 打者のみ
rake scrape:pitcher_record    # 投手のみ
rake delete_retired_player_record  # 退団選手データ削除

# 初回セットアップ (上記を一括実行)
bin/setup
```

## Docker環境

```bash
docker compose build
docker compose up   # PostgreSQL (5433) + webpack-dev-server (3035)
```

`.envrc` (direnv) でDB接続情報を管理:
- `POSTGRES_HOST=127.0.0.1`, `POSTGRES_PORT=5433`, `POSTGRES_USER/PASSWORD`
- `WEBPACKER_DEV_SERVER_HOST=prospects-watcher`

## アーキテクチャ

NPBプロ野球選手の統計情報をYahoo Sports Japanからスクレイピングし、ユーザーがお気に入り選手を登録・比較・閲覧できるWebアプリ。

**スタック**: Ruby 3.0.6 / Rails 6.0.6.1 / PostgreSQL / Vue.js 2 + Vuex + Vuetify 2 / Webpacker / Slim

### データフロー

1. `ScoreScraper` が Yahoo Sports (`baseball.yahoo.co.jp/npb/teams/[team_id]/memberlist`) からHTMLをNokogiriで解析
2. `BatterScore` / `PitcherScore` サービスがデータをパースしてDB更新
3. `ScrapingLog` で実行ログを記録

### 主要モデル関係

- `User` (Devise) → `FavoriteBatter` / `FavoritePitcher` (中間テーブル) → `Batter` / `Pitcher`
- `Team` → `Batter` / `Pitcher` (league enum: central=0, pacific=1)
- `PlayersDataFormatter`: リーグ・チーム別にプレイヤーデータを整形してAPI応答用に構造化

### コントローラー構成

- Web: `PlayersController` (選手検索), `RegisteredPlayersController` (お気に入り一覧), `UsersController` (プロフィール)
- API (`/api/v1/`): `PlayersController`, `FavoriteBattersController`, `FavoritePitchersController`, `RegisteredPlayersController` — すべてJSON

### フロントエンド

`app/javascript/` 配下のVue.jsコンポーネント:
- `AllTeams.vue`: チーム・選手一覧（検索・フィルタ）
- `RegisteredPlayers.vue`: お気に入り選手ダッシュボード
- `CompareBatterScoreTable.vue` / `ComparePitcherScoreTable.vue`: 選手比較テーブル
- `RegisterButton.vue`: お気に入り登録/解除

APIリクエストはVuexのactionsから `axios` 経由で `/api/v1/` エンドポイントに送信する。

### テスト

RSpec + FactoryBot + Capybara (Selenium) によるシステムテスト中心。`spec/system/` に主要フロー（ログイン、選手登録、比較）のテストあり。

### ルート

Root: `registered_players#index`。Deviseの認証ルートあり。メール確認機能有効（開発環境はLetter Opener Web: `/letter_opener`）。
