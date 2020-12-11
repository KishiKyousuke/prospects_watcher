<template>
  <div id="app">
    <h1>チーム別選手一覧</h1>
    <hr>
    <div class="container">
      <div class="team-box">
        <el-collapse v-model="activeNamesCentral" @change="handleChange">
          <el-collapse-item v-for="(team, i) in centralTeams" :key="team" :title="team" :name="i">
          </el-collapse-item>
        </el-collapse>
      </div>
      <div class="team-box">
        <el-collapse v-model="activeNamesPacific" @change="handleChange">
          <el-collapse-item v-for="(team,i) in pacificTeams" :key="team" :title="team" :name="i">
          </el-collapse-item>
        </el-collapse>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data: function () {
    return {
      players: null,
      activeNamesCentral: ['1'],
      activeNamesPacific: ['1'],
      centralTeams: [
        "読売ジャイアンツ",
        "横浜DeNAベイスターズ",
        "阪神タイガース",
        "広島東洋カープ",
        "中日ドラゴンズ",
        "東京ヤクルトスワローズ"
      ],
      pacificTeams: [
        "埼玉西武ライオンズ",
        "福岡ソフトバンクホークス",
        "東北楽天ゴールデンイーグルス",
        "千葉ロッテマリーンズ",
        "北海道日本ハムファイターズ",
        "オリックス・バファローズ",
      ]
    }
  },
  mounted() {
    axios.get('/api/v1/players').then(response => this.players = response.data)
  },
  methods: {
    handleChange(val) {
      console.log(val);
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}

.container {
  display: flex;
  justify-content: center;
}

.team-box {
  margin: auto;
  width: 700px;
}


h2 {
  flex-direction: column;
}
</style>

<style lang="scss" scoped>
/deep/ .el-collapse-item__header{
  font-size: 17px;
  font-weight: bold;
}
</style>