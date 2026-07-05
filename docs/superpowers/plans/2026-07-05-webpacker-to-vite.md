# Webpacker → Vite 移行 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Webpacker 4.x を廃止し、Vite (`vite_rails` gem) に置き換える。Vue コンポーネントの実装・挙動は一切変更しない（ビルドツール移行のみを独立した変更として完結させる）。

**Architecture:** 既存の単一エントリポイント構成（`app/javascript/packs/application.js` が `all_teams.js` / `player_search.js` / `registered_players.js` を import し、3つのDOM要素にVueアプリを個別マウントする構成）をそのまま踏襲する。エントリポイントの置き場所を Vite の規約 (`app/javascript/entrypoints/`) に合わせて移動するだけで、インポートされる子ファイル群（`all_teams.js` 等）や `.vue` ファイルの中身には触れない。Vue 2.6.12 は Vite の公式プラグイン `@vitejs/plugin-vue2` が要求する Vue 2.7 系へ minor bump する（Vue 2.7 は 2.6 に対して後方互換）。フロントエンド開発サーバーは Docker コンテナ経由ではなく、host 上で直接 `bin/vite dev` を実行する方式に変更する（Webpacker が抱えていたコンテナ間ホスト解決の複雑さ (`WEBPACKER_DEV_SERVER_HOST`) を解消するため）。

**Tech Stack:** Ruby 3.2.11 / Rails 7.0.10 / vite_rails (Vite Ruby) / @vitejs/plugin-vue2 / Vue 2.7 / 既存の Vuetify 2, Vuex, Element UI, vue-good-table, vue-simple-suggest はそのまま維持

**この計画に含まれないもの:** React導入、Vueコンポーネントの書き換え、状態管理・UIライブラリの置き換え。これらは本計画の完了後、別の実行計画として着手する（`docs/rails_react_migration_plan.md` Phase 4 手順2以降）。

---

## 現状（移行前）の構成

- `Gemfile`: `gem 'webpacker', '~> 4.0'`
- `package.json` dependencies: `@rails/webpacker 5.4.0`, `vue ^2.6.12`, `vue-template-compiler ^2.6.12`, `vue-loader ^15.9.5`, `file-loader ^6.2.0`, devDependencies: `webpack-dev-server ^3.11.2`
- `config/webpacker.yml`, `config/webpack/{development,test,production,environment}.js`, `config/webpack/loaders/vue.js`
- `bin/webpack`, `bin/webpack-dev-server`
- `config/boot.rb` に Psych 4.0 alias 回避のための webpacker 4.x 向け monkey-patch（Phase 1 で追加、「Phase 4 で削除」と明記済み）
- エントリポイント: `app/javascript/packs/application.js`（`../all_teams`, `../player_search`, `../registered_players`, CSS群を import）
- レイアウト: `app/views/layouts/application.html.slim` の `stylesheet_pack_tag` / `javascript_pack_tag`
- `docker-compose.yml`: `webpacker` サービスが `bin/webpack-dev-server` をコンテナ内で実行（ポート3035）
- `.envrc`: `WEBPACKER_DEV_SERVER_HOST=prospects-watcher`
- `.github/workflows/ci.yml`: Node 16、`bundle exec rails webpacker:compile` ステップ
- `CLAUDE.md`: スタック表記に `Webpacker`、Docker環境説明に `webpack-dev-server (3035)`

## 移行後の構成（本計画のゴール）

- `Gemfile`: `gem 'vite_rails'`
- `package.json`: `vue`/`vue-template-compiler` は `^2.7`、`vite-plugin-ruby` と `@vitejs/plugin-vue2` を追加、`@rails/webpacker` / `vue-loader` / `file-loader` / `webpack-dev-server` を削除
- `vite.config.ts`, `config/vite.json` を新規追加
- エントリポイント: `app/javascript/entrypoints/application.js`（内容は移動のみ、import先は無変更）
- レイアウト: `vite_client_tag` / `vite_javascript_tag`
- `docker-compose.yml`: `db` サービスのみ。フロントエンド開発サーバーは host 上で `bin/vite dev` を直接実行
- `.envrc`: `WEBPACKER_DEV_SERVER_HOST` 行を削除
- CI: Node 20、`bin/vite build` ステップ
- `CLAUDE.md`: スタック表記・Docker環境説明・Commands セクションを更新

---

### Task 1: Vue 2.6 → 2.7 への minor bump（単独で先に検証する）

**目的:** `@vitejs/plugin-vue2` は Vue 2.7 系を対象にした公式プラグインである。ビルドツール移行と同時に Vue のバージョンも上げると、不具合が起きた際にどちらが原因か切り分けられなくなる。まずこのステップ単独で `bundle exec rspec` が全て緑であることを確認する。

**Files:**
- Modify: `package.json`
- Modify: `yarn.lock`（`yarn add` コマンドが自動更新）

- [ ] **Step 1: Vue と vue-template-compiler を 2.7 系に上げる**

```bash
yarn add vue@^2.7 vue-template-compiler@^2.7
```

- [ ] **Step 2: package.json の該当箇所がバージョン範囲 `^2.7.x` に更新されたことを確認**

Run: `grep -A1 '"vue":' package.json`
Expected: `"vue": "^2.7.x"` のような 2.7 系のバージョンが表示される（`x` は yarn が解決した実際のパッチバージョン）

- [ ] **Step 3: 既存のフロントエンド資産をWebpackerでビルドし直し、コンパイルエラーが出ないことを確認**

Run: `bin/webpack-dev-server &` のようなことはせず、代わりに以下でテスト環境の webpack ビルドを直接走らせる:

```bash
RAILS_ENV=test bundle exec rails webpacker:compile
```

Expected: `Compiling...` のあと `Compiled all packs in ...` で正常終了（エラー・warningなし、または既存と同水準のwarningのみ）

- [ ] **Step 4: 既存の全テストスイートを実行し、Vue バージョンアップによる回帰がないことを確認**

Run: `bundle exec rspec`
Expected: 既存のテスト件数がすべて `0 failures` でパスする（システムテスト含む）

- [ ] **Step 5: コミット**

```bash
git add package.json yarn.lock
git commit -m "chore: Vue 2.6 から 2.7 系へ minor bump"
```

---

### Task 2: `vite_rails` を追加導入する（Webpackerと併存させ、まだ切り替えない）

**目的:** この時点ではまだ `app/views/layouts/application.html.slim` は Webpacker のタグを使い続ける。Vite関連ファイルを一式追加するだけの、ユーザーから見て無害な変更にとどめる。

**Files:**
- Modify: `Gemfile`
- Modify: `Gemfile.lock`（`bundle install` が自動更新）
- Create: `vite.config.ts`
- Create: `config/vite.json`
- Create: `bin/vite`（installer が生成）
- Modify: `package.json` / `yarn.lock`

- [ ] **Step 1: Gemfile に vite_rails を追加し、webpacker はまだ残す**

`Gemfile` の以下の行:

```ruby
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
```

の直後に追加:

```ruby
# Frontend build tool (Webpacker の後継). Read more: https://vite-ruby.netlify.app/
gem 'vite_rails'
```

- [ ] **Step 2: bundle install**

```bash
bundle install
```

Expected: `Bundle complete!` で正常終了

- [ ] **Step 3: Vite installer を実行**

```bash
bundle exec vite install
```

Expected: `vite.config.ts`, `config/vite.json`, `bin/vite` が生成され、`package.json` に `vite` / `vite-plugin-ruby` が devDependencies として追加される旨のログが出力される

- [ ] **Step 4: `config/vite.json` の `sourceCodeDir` を既存の `app/javascript` に向ける**

`config/vite.json` を以下の内容に編集する（installer が生成したデフォルト値に `sourceCodeDir` を追加した形）:

```json
{
  "all": {
    "sourceCodeDir": "app/javascript",
    "watchAdditionalPaths": []
  },
  "development": {
    "autoBuild": true,
    "publicOutputDir": "vite-dev",
    "port": 3036
  },
  "test": {
    "autoBuild": true,
    "publicOutputDir": "vite-test",
    "port": 3037
  }
}
```

- [ ] **Step 5: `@vitejs/plugin-vue2` を追加し、`vite.config.ts` に組み込む**

```bash
yarn add -D @vitejs/plugin-vue2
```

`vite.config.ts` を以下の内容に編集:

```typescript
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue2 from '@vitejs/plugin-vue2'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue2(),
  ],
})
```

- [ ] **Step 6: 既存の Webpacker 経由のページがまだ問題なく動くことを確認（この時点ではVite側はまだレイアウトから参照されていない）**

Run: `bundle exec rspec`
Expected: Task 1 と同様、全テストがパスする（Vite関連ファイルの追加が既存動作に影響していないことの確認）

- [ ] **Step 7: コミット**

```bash
git add Gemfile Gemfile.lock package.json yarn.lock vite.config.ts config/vite.json bin/vite
git commit -m "chore: vite_rails を追加導入（Webpackerとまだ併存、切り替えは次コミット）"
```

**実装メモ:** 実際の実装では `vite` は installer デフォルトの `^8.1.3` ではなく `^6.4.3` に固定した。理由は開発機の Node が 18.18.2 であり、Vite 8 の `engines.node`（`^20.19.0 || >=22.12.0`）を満たさず `yarn add` がエンジンチェックで失敗するため。この固定は Task 6 で CI/開発環境の Node を 20 系以上に上げた際に見直すこと（Node 18 を使い続ける環境が残っている限りは `^6` のままにする）。

---

### Task 3: エントリポイントを移動し、レイアウトを Vite タグに切り替える（本丸のカットオーバー）

**Files:**
- Move: `app/javascript/packs/application.js` → `app/javascript/entrypoints/application.js`
- Modify: `app/views/layouts/application.html.slim`

- [ ] **Step 1: エントリポイントを Vite の規約ディレクトリに移動**

```bash
mkdir -p app/javascript/entrypoints
git mv app/javascript/packs/application.js app/javascript/entrypoints/application.js
rmdir app/javascript/packs
```

`app/javascript/entrypoints/application.js` の中身はそのまま変更しない（`../all_teams` 等の相対パスは `app/javascript/` 直下を指しており、`packs/` から `entrypoints/` への移動後も相対階層は変わらないため無修正で動く）:

```javascript
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import Vue from 'vue'
import ElementUI from 'element-ui'
import Vuetify from 'vuetify'

Vue.use(ElementUI)
Vue.use(Vuetify)

import '../css/application.css'
import 'element-ui/lib/theme-chalk/index.css'
import 'vuetify/dist/vuetify.min.css'
import '@mdi/font/css/materialdesignicons.css'

import '../all_teams'
import '../player_search'
import '../registered_players'
```

- [ ] **Step 2: レイアウトの pack タグを Vite タグに置き換える**

`app/views/layouts/application.html.slim` の以下の行:

```slim
= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
```

を以下に置き換える（`application.js` が CSS を import しているため `vite_javascript_tag` が対応するスタイルタグも自動挿入する。個別の `vite_stylesheet_tag` は不要）:

```slim
= vite_client_tag
= vite_javascript_tag 'application', 'data-turbolinks-track': 'reload'
```

- [ ] **Step 3: フロントエンド開発サーバーを起動し、手動で疎通確認**

別ターミナルで Vite dev server を起動:

```bash
bin/vite dev
```

Expected: `VITE vX.X.X ready` のようなログが出て `Local: http://localhost:3036/` が表示される

同時に Rails サーバーを起動し、ブラウザで以下を確認する:

```bash
bundle exec rails s
```

- `http://localhost:3000/players`（AllTeams.vue がマウントされるページ）でチーム一覧・選手検索が表示される
- `http://localhost:3000/registered_players`（ログイン後）でお気に入り選手一覧が表示される
- ブラウザの開発者ツールのコンソールにエラーが出ていない

- [ ] **Step 4: システムテストスイートを実行し、実際のブラウザ経由でVue部分の描画・操作が壊れていないことを確認**

```bash
bundle exec rspec spec/system
```

Expected: `authentication_spec.rb`, `login_spec.rb`, `registered_players_spec.rb`, `team_players_spec.rb` を含む全システムテストが `0 failures` でパスする（これらのテストは実ブラウザでVueマウント部分のUIを操作するため、Vite移行によるレンダリング崩れがあればここで検出される）

- [ ] **Step 5: 全テストスイートを実行**

```bash
bundle exec rspec
```

Expected: 全件パス

- [ ] **Step 6: コミット**

```bash
git add app/javascript/entrypoints app/views/layouts/application.html.slim
git commit -m "feat: Webpackerのpack tagからVite tagへ切り替え、エントリポイントをentrypoints/へ移動"
```

---

### Task 4: Webpacker を完全に撤去する

**Files:**
- Modify: `Gemfile`, `Gemfile.lock`
- Modify: `package.json`, `yarn.lock`
- Delete: `config/webpacker.yml`, `config/webpack/`, `bin/webpack`, `bin/webpack-dev-server`
- Modify: `config/boot.rb`

- [ ] **Step 1: Gemfile から webpacker を削除**

`Gemfile` から以下の2行を削除:

```ruby
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
```

```bash
bundle install
```

- [ ] **Step 2: package.json から webpacker 関連パッケージを削除**

```bash
yarn remove @rails/webpacker vue-loader file-loader webpack-dev-server
```

- [ ] **Step 3: Webpacker の設定ファイル・binスタブを削除**

```bash
git rm -r config/webpacker.yml config/webpack bin/webpack bin/webpack-dev-server
```

- [ ] **Step 4: `config/boot.rb` から Phase 1 の monkey-patch を除去**

`config/boot.rb` を以下の内容に置き換える（`require 'logger'` は Rails 6.1 + Ruby 3.2 対応のため Phase 4 後も残す。YAML alias 対応のカスタム `Bootsnap.setup` 呼び出しと `YAML.load_file` の再定義は webpacker 4.x の内部YAML専用の暫定対処だったため、標準の `require 'bootsnap/setup'` に戻す）:

```ruby
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'logger' # Rails 6.1 + Ruby 3.2: Logger は stdlib gem 化されたため明示 require が必要
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
```

- [ ] **Step 5: 全テストスイートを実行し、Webpacker撤去による破壊がないことを確認**

```bash
bundle exec rspec
```

Expected: 全件パス

- [ ] **Step 6: rubocop を実行**

```bash
bundle exec rubocop
```

Expected: `no offenses detected`

- [ ] **Step 7: コミット**

```bash
git add Gemfile Gemfile.lock package.json yarn.lock config/boot.rb
git commit -m "chore: Webpackerを完全に撤去"
```

---

### Task 5: Docker / 環境変数まわりを整理する

**目的:** Webpacker がコンテナ内で `bin/webpack-dev-server` を実行し、host 上の Rails から見えるようにするために `WEBPACKER_DEV_SERVER_HOST` を使っていた。Vite の dev server は host 上で直接動かす方式に切り替え、この複雑さ自体を無くす。

**Files:**
- Modify: `docker-compose.yml`
- Modify: `.envrc`

- [ ] **Step 1: docker-compose.yml から webpacker サービスを削除**

`docker-compose.yml` を以下の内容に置き換える:

```yaml
version: '3'
services:
  db:
    image: postgres:17
    environment:
      POSTGRES_USER: prospects_watcher
      POSTGRES_PASSWORD: password
      POSTGRES_DB: prospects_watcher_development
    volumes:
      - "db-data:/var/lib/postgresql/data"
    ports:
      - '5433:5432'

volumes:
  db-data:
```

- [ ] **Step 2: .envrc から WEBPACKER_DEV_SERVER_HOST を削除**

`.envrc` から以下の行を削除:

```
export WEBPACKER_DEV_SERVER_HOST=prospects-watcher
```

```bash
direnv allow
```

- [ ] **Step 3: `docker compose up` で DB のみ起動することを確認**

```bash
docker compose up -d
docker compose ps
```

Expected: `db` サービスのみが起動している（`webpacker` サービスが存在しないこと）

- [ ] **Step 4: host 上で `bin/vite dev` + `bundle exec rails s` を起動し、Task 3 Step 3 と同様の手動疎通確認を再実施**

```bash
bin/vite dev &
bundle exec rails s
```

Expected: `http://localhost:3000` の各ページが問題なく表示される

- [ ] **Step 5: コミット**

```bash
git add docker-compose.yml .envrc
git commit -m "chore: docker-composeからwebpackerサービスを削除、Vite dev serverはhost上で直接実行する方式に変更"
```

---

### Task 6: CI ワークフローを更新する

**Files:**
- Modify: `.github/workflows/ci.yml`

- [ ] **Step 1: Node のバージョンを 20 に上げる（Vite 5+ は Node 18 以上が必須）**

`.github/workflows/ci.yml` の以下の箇所:

```yaml
      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: 16
          cache: yarn
```

を以下に変更:

```yaml
      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: yarn
```

- [ ] **Step 2: webpacker:compile ステップを vite build に置き換える**

以下の箇所:

```yaml
      - name: Compile webpack assets
        run: bundle exec rails webpacker:compile
```

を以下に変更:

```yaml
      - name: Build frontend assets
        run: bin/vite build
```

- [ ] **Step 3: ローカルで RAILS_ENV=test を指定して同等のビルドが通ることを確認（CI環境の代替確認）**

```bash
RAILS_ENV=test bin/vite build
```

Expected: `vite v.X.X.X building for production...` のあと `built in ...` で正常終了し、`public/vite-test/` 配下にビルド成果物が生成される

- [ ] **Step 4: コミット**

```bash
git add .github/workflows/ci.yml
git commit -m "ci: Node 20に更新し、vite buildでフロントエンド資産をビルドするよう変更"
```

- [ ] **Step 5: リモートにpushしてCIが実際に緑になることを確認**

（pushはユーザーに確認の上で実施すること。CI結果は `gh run list` / `gh run watch` で確認する）

---

### Task 7: 不要ファイルの掃除

**Files:**
- Delete: `package-lock.json`

- [ ] **Step 1: 使われていない package-lock.json を削除する**

このリポジトリは `yarn.lock` を正としている（CI も `yarn install --frozen-lockfile` を使用）。`package-lock.json` は2023年3月から更新されておらず、npm を使う運用は行われていない。

```bash
git rm package-lock.json
```

- [ ] **Step 2: yarn install が引き続き問題なく通ることを確認**

```bash
yarn install --frozen-lockfile
```

Expected: エラーなく完了

- [ ] **Step 3: コミット**

```bash
git commit -m "chore: 未使用のpackage-lock.jsonを削除（yarn.lockが正）"
```

---

### Task 8: ドキュメントを更新する

**Files:**
- Modify: `CLAUDE.md`
- Modify: `docs/rails_react_migration_plan.md`

- [ ] **Step 1: CLAUDE.md のスタック表記を更新**

`CLAUDE.md` の以下の行:

```
**スタック**: Ruby 3.2.11 / Rails 7.0.10 / PostgreSQL / Vue.js 2 + Vuex + Vuetify 2 / Webpacker / Slim
```

を以下に変更:

```
**スタック**: Ruby 3.2.11 / Rails 7.0.10 / PostgreSQL / Vue.js 2.7 + Vuex + Vuetify 2 / Vite / Slim
```

- [ ] **Step 2: CLAUDE.md の Docker環境セクションを更新**

```
docker compose up   # PostgreSQL (5433) + webpack-dev-server (3035)
```

を以下に変更:

```
docker compose up   # PostgreSQL (5433)
bin/vite dev        # フロントエンド開発サーバー（HMR）。host上で直接実行する
```

`.envrc` の説明箇条書きから `WEBPACKER_DEV_SERVER_HOST=prospects-watcher` の行を削除する。

- [ ] **Step 3: CLAUDE.md の Commands セクションに vite build を追記**

`# スクレイピング` セクションの前に以下を追記:

```
# フロントエンドの本番ビルド確認
bin/vite build
```

- [ ] **Step 4: docs/rails_react_migration_plan.md の進行ステータスを更新**

`## 進行ステータス` の以下の行:

```
- [ ] Phase 4 — Webpacker脱却 + Vue → React 移行 ← **次の着手ポイント**
```

を以下に変更（Phase 4自体はまだ未完了なので、サブステップの進捗を注記する形にする）:

```
- [ ] Phase 4 — Webpacker脱却 + Vue → React 移行
  - [x] Step 1: Webpacker → Vite 移行 ✅
  - [ ] Step 2以降: Reactストラングラー導入 ← **次の着手ポイント**
```

- [ ] **Step 5: コミット**

```bash
git add CLAUDE.md docs/rails_react_migration_plan.md
git commit -m "docs: Webpacker→Vite移行完了をCLAUDE.mdとマイグレーション計画に反映"
```

---

### Task 9: 最終確認

- [ ] **Step 1: 全テストスイートを実行**

```bash
bundle exec rspec
```

Expected: 全件パス（Task開始前と同じ件数、失敗0件）

- [ ] **Step 2: rubocop を実行**

```bash
bundle exec rubocop
```

Expected: `no offenses detected`

- [ ] **Step 3: クリーンな状態から `bin/setup` 相当のセットアップが通ることを確認（新規開発者のオンボーディングが壊れていないか）**

```bash
bundle install
yarn install --frozen-lockfile
bin/rails db:prepare
```

Expected: エラーなく完了

- [ ] **Step 4: git status がクリーンであることを確認し、このブランチをPR化する準備が整ったことを報告する**

```bash
git status
```

Expected: `nothing to commit, working tree clean`

---

## Self-Review メモ

- **Spec coverage**: `docs/rails_react_migration_plan.md` Phase 4 手順1の全項目（vite_rails導入、config/vite.json・vite.config.ts設定、レイアウトタグ置換、Webpacker関連設定の削除）を Task 1〜7 でカバーした。CI・Docker・ドキュメント更新も漏れなくタスク化した。
- **Placeholder scan**: バージョン番号は `yarn add` コマンドに範囲指定（`^2.7` 等）を委ね、正確な解決済みバージョンをその場で確認する手順にしたことで、不正確な決め打ちバージョンを記載していない。
- **Type consistency**: `config/vite.json` の `sourceCodeDir` と `vite.config.ts` の設定、レイアウトの `vite_javascript_tag 'application'` が指すファイル名（`entrypoints/application.js`）が一致していることを確認済み。
