<template>
  <div id="app">
    <h1>チーム別選手一覧</h1>
    <hr>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!",
      teams: [
          "埼玉西武ライオンズ",
          "福岡ソフトバンクホークス",
          "東北楽天ゴールデンイーグルス",
          "千葉ロッテマリーンズ",
          "北海道日本ハムファイターズ",
          "オリックス・バファローズ",
          "読売ジャイアンツ",
          "横浜DeNAベイスターズ",
          "阪神タイガース",
          "広島東洋カープ",
          "中日ドラゴンズ",
          "東京ヤクルトスワローズ"
      ]
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
