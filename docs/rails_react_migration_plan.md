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
- [ ] Phase 1 — Ruby 3.0.6 → 3.2.x  ← **次の着手ポイント**
- [ ] Phase 2 — Rails 6.0 → 6.1
- [ ] Phase 3 — Rails 6.1 → 7.0（Webpackerは温存）
- [ ] Phase 4 — Webpacker脱却 + Vue → React 移行
- [ ] Phase 5 — Rails 7.0 → 7.1 → 7.2 → 8.0

着手・完了したフェーズはチェックを更新すること。

## 基本方針

1. **複数の大改修を同時にやらない**。RailsアップグレードとReact移行は明確に分離する。
2. PRは小さく刻む。各フェーズ内でも段階的にマージできる単位に分割する。
3. CI（システムテスト含む）が緑であることを各ステップで確認。
4. デプロイは止めない。masterは常にリリース可能な状態を保つ。

## フェーズ詳細

### Phase 1 — Ruby 3.0.6 → 3.2.x

**目的**: 後続の Rails 7.1+ 移行（Ruby 3.1+ 必須）の前提を整える。Rails 6.0 のままでも Ruby 3.2 は動作する。

- `.ruby-version` / Gemfile / CI設定 / Dockerfile の Ruby バージョンを統一して引き上げ
- `bundle install` 後の警告・互換性問題を解消
- 全テストを緑に戻す
- Rails本体は触らない

### Phase 2 — Rails 6.0 → 6.1

- `rails app:update` を実行し、差分を吟味してマージ
- `config/initializers/new_framework_defaults_6_1.rb` の各フラグを段階的に有効化
- Zeitwerk モードへの完全移行をここで確定（`config.autoloader = :zeitwerk`）
- deprecation warning を可能な限り解消

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
