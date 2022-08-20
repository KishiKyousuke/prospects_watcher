# ProspectsWatcher

Prospects Watcherは、複数のプロ野球選手の個人成績を確認する事ができる個人成績確認ツールです。
一般的なプロ野球情報サイトとは異なり、チームをまたいでお気に入りの選手の成績を一覧画面で確認することができます。
注目選手を登録してあなただけの個人成績一覧を作成頂けます。

## 選手の登録
### チーム一覧から選択する
https://user-images.githubusercontent.com/59789739/141323238-5c2594f9-a000-4793-ab75-74892160e1a3.mov

### 選手名で検索する

https://user-images.githubusercontent.com/59789739/141320287-f0e5c727-cc1e-48ab-8f1c-7bf1f2fc679c.mov

## 選手の成績を比較する
### 各成績でソートを行う

https://user-images.githubusercontent.com/59789739/141321312-f973959b-038e-45a5-b2aa-5d80b106c692.mov

### 2選手の比較

https://user-images.githubusercontent.com/59789739/141321834-353f1568-46ee-40f3-945e-3df5e885928c.mov


## アプリケーションの起動に必要な行程
1. `docker compose build`を実行
2. `docker compose up`を実行してアプリケーションを起動
3. `docker compose web bash`でbashに接続し、`bin/rails db:seed`を実行
4. bashに接続した状態で`bin/rails scrape:player_record`を実行
