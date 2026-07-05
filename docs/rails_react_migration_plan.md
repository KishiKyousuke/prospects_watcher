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
- [x] Phase 3 — Rails 6.1 → 7.0（Webpackerは温存）
- [ ] Phase 4 — Webpacker脱却 + Vue → React 移行 ← **次の着手ポイント**
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

### Phase 3 — Rails 6.1 → 7.0（Webpackerは温存）✅

- フロントエンド環境には**手を入れない**。Webpacker gem は7.0でも動作する（deprecation警告は出る）
- `rails app:update` 適用、`load_defaults 7.0` に更新（PR #128）
- `config/initializers/new_framework_defaults_7_0.rb` の全フラグを有効化した上で削除
- `urlsafe_csrf_tokens` を有効化（6.1 defaults の保留フラグを解消）
- ActiveStorage の checksum NOT NULL 制約削除マイグレーションを適用
- `key_generator_hash_digest_class` / `hash_digest_class` を SHA256 に変更
- `cookies_serializer = :json`、`cache_format_version = 7.0`、`disable_to_s_conversion = true` を有効化
- devise の `skip_after_callbacks_if_terminated=` deprecation は devise gem 側の問題。Rails 7.1 移行前に devise アップデートで解消予定
- 142件のテストが全てパス（PR #128）

### Phase 4 — Webpacker脱却 + Vue → React 移行（本丸）

Rails 7.0 上で **Vite** (`vite_rails` gem) に置換する。

**ビルドツールに Vite を選定した理由（2026-07-05 決定）**: 当初案の `jsbundling-rails` (esbuild) は Vue 2 の `.vue` 単一ファイルコンポーネントを正式サポートするesbuildプラグインが存在せず、コミュニティ製の非公式プラグインに頼ることになる。本番稼働中ではない（＝切り戻しコストが低い）ことを踏まえても、Vue/React併存期間中に不安定な非公式プラグインへ依存するリスクは避けるべきと判断した。Vite は公式の `@vitejs/plugin-vue2`（Vue 2.7系）と公式の `@vitejs/plugin-react` の両方が揃っており、併存期間の安定性が高い。

Webpacker → Vite の移行作業と Vue → React の書き換えはどちらもビルド設定への対応を含むため、二段階に分けると重複工数が発生する——という当初の判断は撤回し、**ビルドツール移行（Vue動作は無改修で完全維持）を独立した最初のステップとして先に完了させる**。これにより「ビルドツールを変えた」ことによる不具合と「Reactへの書き換え」による不具合を混同せず切り分けられる。

#### 手順

1. **Webpacker → Vite 移行**（本ステップ。Vueコンポーネントの内容は一切変更しない）
   - 前提として Vue 2.6.12 → 2.7系へ minor bump（`@vitejs/plugin-vue2` が公式サポートするのは Vue 2.7系のため）
   - `vite_rails` gem 導入、`config/vite.json` / `vite.config.ts` を設定（`sourceCodeDir` は既存の `app/javascript` を踏襲し、`packs/` は `entrypoints/` に置き換え）
   - レイアウトの `javascript_pack_tag` / `stylesheet_pack_tag` を `vite_client_tag` / `vite_javascript_tag` に置換
   - Webpacker関連設定 (`config/webpacker.yml`, `config/webpack/`, `bin/webpack*`, `config/boot.rb` のYAML alias monkey-patch) を削除
   - 詳細は `docs/superpowers/plans/2026-07-05-webpacker-to-vite.md` を参照
2. **ストラングラーパターン**で Vue と React を一時併存させる（`@vitejs/plugin-react` を追加導入）
3. コンポーネント置換順（依存の浅いものから）:
   - `RegisterButton.vue` → React版（`TeamPlayers.vue` にネストされたリーフ）
   - `CompareBatterScoreTable.vue` / `ComparePitcherScoreTable.vue`（`RegisteredBatters.vue` / `RegisteredPitchers.vue` にネストされたリーフ）
   - `AllTeams.vue`（`TeamPlayers.vue` ごと巻き取り）
   - `PlayerSearch.vue`（vue-simple-suggest相当のReact実装が必要。当初リストに漏れていたため追加）
   - `RegisteredPlayers.vue`（`RegisteredBatters.vue` / `RegisteredPitchers.vue` / `BlankPage.vue` ごと巻き取り。最後・最も状態が複雑）
4. 状態管理: Vuex (`store.js`) → **Zustand** または **Redux Toolkit**（このアプリ規模ならZustandで十分）
   - `store.js` の `updateFlag` は `PlayerSearch` と `RegisteredPlayers` 間の更新通知に使われている。React移行後も同等の通知手段を用意すること
5. UIライブラリ: Vuetify 2 → **MUI v5**（移行コスト最小）。Element UI（`TeamPlayers.vue` の `el-table`）、vue-good-table（`RegisteredBatters.vue` / `RegisteredPitchers.vue`）、vue-simple-suggest（`PlayerSearch.vue`）も同時期に置き換え対象
   - 移行開始時に Vuetify → MUI のコンポーネント対応表を作成
6. API側 (`/api/v1/`) は無改修
7. 各コンポーネント置換ごとにシステムテストで動作確認

#### 注意点

- Vue / React 併存期間は**できる限り短く**保つ。半年以上の並走は避ける
- 比較テーブルは挙動差分が出やすい。スクリーンショット比較か手動QAリストを用意
- Vue関連パッケージ (`vue`, `vuex`, `vuetify`, `element-ui`, `vue-good-table`, `vue-simple-suggest`, `vue-template-compiler`, `@vitejs/plugin-vue2`) は React 移行完了後に削除

### Phase 5 — Rails 7.0 → 7.1 → 7.2 → 8.0

- 各バージョン間は `rails app:update` と `load_defaults` の段階適用を機械的に
- Ruby 3.2+ 必須（Phase 1で対応済み）
- Rails 8.0 の Solid Queue / Solid Cache / Propshaft 等への移行は**別PR**で分割
- 既存の Sprockets + ActiveJob 構成のままでも 8.0 は動作する。急がない

## 参考リンク

- Rails Upgrade Guide: https://guides.rubyonrails.org/upgrading_ruby_on_rails.html
- Vite Ruby: https://vite-ruby.netlify.app/guide/
- vite-plugin-vue2 (公式, Vue 2.7): https://github.com/vitejs/vite-plugin-vue2
- Webpacker retirement: https://github.com/rails/webpacker
