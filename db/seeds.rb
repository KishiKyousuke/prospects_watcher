# frozen_string_literal: true

Team.create!(
  [
    {
      name: 'ソフトバンク',
      formal_name: '福岡ソフトバンクホークス',
      ranking: 3,
      league: :pacific,
      url_id: 12,
      english_name: 'hawks'
    },
    {
      name: 'ロッテ',
      formal_name: '千葉ロッテマリーンズ',
      ranking: 2,
      league: :pacific,
      url_id: 9,
      english_name: 'marines'
    },
    {
      name: '西武',
      formal_name: '埼玉西武ライオンズ',
      ranking: 5,
      league: :pacific,
      url_id: 7,
      english_name: 'lions'
    },
    {
      name: '楽天',
      formal_name: '東北楽天ゴールデンイーグルス',
      ranking: 4,
      league: :pacific,
      url_id: 376,
      english_name: 'eagles'
    },
    {
      name: '日本ハム',
      formal_name: '北海道日本ハムファイターズ',
      ranking: 6,
      league: :pacific,
      url_id: 8,
      english_name: 'fighters'
    },
    {
      name: 'オリックス',
      formal_name: 'オリックス・バファローズ',
      ranking: 1,
      league: :pacific,
      url_id: 11,
      english_name: 'buffaloes'
    },
    {
      name: '巨人',
      formal_name: '読売ジャイアンツ',
      ranking: 4,
      league: :central,
      url_id: 1,
      english_name: 'giants'
    },
    {
      name: '阪神',
      formal_name: '阪神タイガース',
      ranking: 1,
      league: :central,
      url_id: 5,
      english_name: 'tigers'
    },
    {
      name: '中日',
      formal_name: '中日ドラゴンズ',
      ranking: 6,
      league: :central,
      url_id: 4,
      english_name: 'dragons'
    },
    {
      name: 'DeNA',
      formal_name: '横浜DeNAベイスターズ',
      ranking: 3,
      league: :central,
      url_id: 3,
      english_name: 'baystars'
    },
    {
      name: '広島',
      formal_name: '広島東洋カープ',
      ranking: 2,
      league: :central,
      url_id: 6,
      english_name: 'carp'
    },
    {
      name: 'ヤクルト',
      formal_name: '東京ヤクルトスワローズ',
      ranking: 5,
      league: :central,
      url_id: 2,
      english_name: 'swallows'
    }
  ]
)
