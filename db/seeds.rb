# frozen_string_literal: true

Team.create!(
  [
    {
      name: "ソフトバンク",
      formal_name: "福岡ソフトバンクホークス",
      ranking: 1,
      league: :pacific,
      url_id: 12
    },
    {
      name: "ロッテ",
      formal_name: "千葉ロッテマリーンズ",
      ranking: 2,
      league: :pacific,
      url_id: 9
    },
    {
      name: "西武",
      formal_name: "埼玉西部ライオンズ",
      ranking: 3,
      league: :pacific,
      url_id: 7
    },
    {
      name: "楽天",
      formal_name: "東北楽天ゴールデンイーグルス",
      ranking: 4,
      league: :pacific,
      url_id: 376
    },
    {
      name: "日本ハム",
      formal_name: "北海道日本ハムファイターズ",
      ranking: 5,
      league: :pacific,
      url_id: 8
    },
    {
      name: "オリックス",
      formal_name: "オリックス・バファローズ",
      ranking: 6,
      league: :pacific,
      url_id: 11
    },
    {
      name: "巨人",
      formal_name: "読売ジャイアンツ",
      ranking: 1,
      league: :central,
      url_id: 1
    },
    {
      name: "阪神",
      formal_name: "阪神タイガース",
      ranking: 2,
      league: :central,
      url_id: 5
    },
    {
      name: "中日",
      formal_name: "中日ドラゴンズ",
      ranking: 3,
      league: :central,
      url_id: 4
    },
    {
      name: "DeNA",
      formal_name: "横浜DeNAベイスターズ",
      ranking: 4,
      league: :central,
      url_id: 3
    },
    {
      name: "広島",
      formal_name: "広島東洋カープ",
      ranking: 5,
      league: :central,
      url_id: 6
    },
    {
      name: "ヤクルト",
      formal_name: "東京ヤクルトスワローズ",
      ranking: 6,
      league: :central,
      url_id: 2
    }
  ]
)
