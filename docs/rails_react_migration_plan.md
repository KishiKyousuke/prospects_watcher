# Rails アップグレード & Vue → React 移行計画

このドキュメントは prospects_watcher のアップグレード進行を追跡する正本である。
Claude Code は新規セッションでこのファイルを読み、現在のフェーズを把握してから作業に入ること。

## 起点（2026-05-07 時点）

- Ruby: 3.0.6
- Rails: 6.0.6.1
- フロント: Vue 2 + Vuex + Vuetify 2
- ビルド: Webpacker
- API: `/api/v1/` (JSONのみ、バックエンド改修不要)

## 進行ステータス

- [x] Phase 0 — テスト強化（システムテスト・ユニットテスト整備済み）
- [x] Phase 1 — Ruby 3.0.6 → 3.2.11
- [x] Phase 2 — Rails 6.0 → 6.1
- [ ] Phase 3 — Rails 6.1 → 7.0（Webpackerは温存）← **次の着手ポイント**
- [ ] Phase 4 — Webpacker脱却 + Vue → React 移行
- [ ] Phase 5 — Rails 7.0 → 7.1 → 7.2 → 8.0

着手・完了したフェーズはチェックを更新すること。

## 基本方針

1. **複数の大改修を同時にやらない**。RailsアップグレードとReact移行は明確に分離する。
2. PRは小さく刻む。各フェーズ内でも段階的にマージできる単位に分割する。
3. CI（システムテスト含む）が緑であることを各ステップで確認。
4. デプロイは止めない。masterは常にリリース可能な状態を保つ。

## フェーズ詳細

### Phase 1 — Ruby 3.0.6 → 3.2.11 ✅

**目的**: 後続の Rails 7.1+ 移行（Ruby 3.1+ 必須）の前提を整える。Rails 6.0 のままでも Ruby 3.2 は動作する。

- `.ruby-version` / `Gemfile` / `Dockerfile` の Ruby バージョンを 3.2.11 に統一（CI は `.ruby-version` から自動取得）
- `html2slim` gem を削除（Ruby 3.x で build 不能な `hpricot` に依存。テンプレートはすでに Slim 化済みのため不要）
- `config/database.yml` / `config/webpacker.yml` の YAML alias 記法（`<<: *default`）を展開して排除（Psych 4.0 の alias デフォルト無効化に対応）
- `config/boot.rb` に暫定 monkey-patch を追加（webpacker 4.x gem 内部の `lib/install/config/webpacker.yml` が alias を使用しており、gem 側を直接変更できないため。Phase 4 の webpacker 削除時に除去すること）
- フロントエンド・Rails本体には手を入れない
- Flakyテストを修正（`spec/system/` 2ファイル、Vue の非同期 API 待機漏れによる CI タイミング問題）

### Phase 2 — Rails 6.0 → 6.1 ✅

- `rails app:update` を実行し、差分を吟味してマージ
- `config/boot.rb` に `require 'logger'` を追加（Ruby 3.2 + Rails 6.1 の互換性対応。Phase 4のwebpacker削除後も残す）
- `config/initializers/new_framework_defaults_6_1.rb` の安全なフラグを有効化
  - 保留中（Rails 8.0 到達後に整理）: `cookies_same_site_protection`, `urlsafe_csrf_tokens`, `utc_to_local_returns_utc_offset_times`, `form_with_generates_remote_forms`
- ActiveStorage マイグレーション 2件を適用（service_name カラム追加 / variant records テーブル作成）
- 142件のテストが全てパス（PR #127）

### Phase 3 — Rails 6.1 → 7.0（Webpackerは温存）

- フロントエンド環境には**手を入れない**。Webpacker gem は7.0でも動作する（deprecation警告は出る）
- `rails app:update` 適用、`load_defaults 7.0` を段階的に
- credentials の multi-environment 化を整理
- ActiveRecord の暗号化、非同期クエリなどの新機能は必要に応じて

### Phase 4 — Webpacker脱却 + Vue → React 移行（本丸）

Rails 7.0 上で `jsbundling-rails` (esbuild) に置換し、**同時に** React を導入する。
Webpacker → jsbundling の移行作業と Vue → React の書き換えはどちらも esbuild への対応を含むため、二段階に分けると重複工数が発生する。

#### 手順

1. `jsbundling-rails` (esbuild) を導入、`app/javascript/application.js` をエントリポイントに設定
2. **ストラングラーパターン**で Vue と React を一時併存させる
3. コンポーネント置換順（依存の浅いものから）:
   - `RegisterButton.vue` → React版
   - `CompareBatterScoreTable.vue` / `ComparePitcherScoreTable.vue`
   - `AllTeams.vue`
   - `RegisteredPlayers.vue`（最後・最も状態が複雑）
4. 状態管理: Vuex → **Zustand** または **Redux Toolkit**（このアプリ規模ならZustandで十分）
5. UIライブラリ: Vuetify 2 → **MUI v5**（移行コスト最小）
   - 移行開始時に Vuetify → MUI のコンポーネント対応表を作成
6. API側 (`/api/v1/`) は無改修
7. 各コンポーネント置換ごとにシステムテストで動作確認

#### 注意点

- Vue / React 併存期間は**できる限り短く**保つ。半年以上の並走は避ける
- 比較テーブルは挙動差分が出やすい。スクリーンショット比較か手動QAリストを用意
- Webpacker関連設定 (`config/webpacker.yml`, `config/webpack/`, `bin/webpack*`) は移行完了後に削除

### Phase 5 — Rails 7.0 → 7.1 → 7.2 → 8.0

- 各バージョン間は `rails app:update` と `load_defaults` の段階適用を機械的に
- Ruby 3.2+ 必須（Phase 1で対応済み）
- Rails 8.0 の Solid Queue / Solid Cache / Propshaft 等への移行は**別PR**で分割
- 既存の Sprockets + ActiveJob 構成のままでも 8.0 は動作する。急がない

## 参考リンク

- Rails Upgrade Guide: https://guides.rubyonrails.org/upgrading_ruby_on_rails.html
- jsbundling-rails: https://github.com/rails/jsbundling-rails
- Webpacker retirement: https://github.com/rails/webpacker
