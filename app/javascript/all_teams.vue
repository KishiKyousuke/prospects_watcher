<template>
  <div id="app">
    <h1>チーム別選手一覧</h1>
    <hr>
    <div class="container">
      <el-collapse v-model="activeNamesCentral" @change="handleChange" class="central-teams-box">
        <h2>セ・リーグ</h2>
        <el-collapse-item v-for="(formalName, team, i) in centralTeams" :key="team" :title="formalName" :name="i">
          <teamPlayers :selected-team="team"></teamPlayers>
        </el-collapse-item>
      </el-collapse>
      <el-collapse v-model="activeNamesPacific" @change="handleChange" class="pacific-teams-box">
        <h2>パ・リーグ</h2>
        <el-collapse-item v-for="(formalName, team, i) in pacificTeams" :key="team" :title="formalName" :name="i">
          <teamPlayers :selected-team="team"></teamPlayers>
        </el-collapse-item>
      </el-collapse>
    </div>
  </div>
</template>

<script>
import TeamPlayers from "./team_players"

export default {
  data: function () {
    return {
      activeNamesCentral: ['1'],
      activeNamesPacific: ['1'],
      centralTeams: {
        巨人: "読売ジャイアンツ",
        DeNA: "横浜DeNAベイスターズ",
        阪神: "阪神タイガース",
        広島: "広島東洋カープ",
        中日: "中日ドラゴンズ",
        ヤクルト: "東京ヤクルトスワローズ"
      },
      pacificTeams: {
        西武: "埼玉西武ライオンズ",
        ソフトバンク: "福岡ソフトバンクホークス",
        楽天: "東北楽天ゴールデンイーグルス",
        ロッテ: "千葉ロッテマリーンズ",
        日本ハム: "北海道日本ハムファイターズ",
        オリックス: "オリックス・バファローズ"
      }
    }
  },
  components: {
    TeamPlayers
  }
}
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
}

.central-teams-box, .pacific-teams-box {
  width: 700px;
  margin: 0 5px;
}
</style>

<style lang="scss" scoped>
/deep/ .el-collapse-item__header{
  font-size: 17px;
  font-weight: bold;
}
</style>
