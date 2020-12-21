<template>
  <div id="app" class="row">
    <div class="col s12">
      <h4>チーム別選手一覧</h4>
    </div>
    <div class="col l6 s12">
      <h5 style="font-weight: bold">セ・リーグ</h5>
      <el-collapse v-model="activeNamesCentral">
        <el-collapse-item v-for="(formalName, team, i) in centralTeams" :key="team" :title="formalName" :name="i">
          <team-players v-if="showTeamPlayersComponent" :selected-team="team" :players="players" :registered-players="registeredPlayers"></team-players>
        </el-collapse-item>
      </el-collapse>
    </div>
    <div class="col l6 s12">
      <h5 style="font-weight: bold">パ・リーグ</h5>
      <el-collapse v-model="activeNamesPacific">
        <el-collapse-item v-for="(formalName, team, i) in pacificTeams" :key="team" :title="formalName" :name="i">
          <team-players v-if="showTeamPlayersComponent" :selected-team="team" :players="players" :registered-players="registeredPlayers"></team-players>
        </el-collapse-item>
      </el-collapse>
    </div>
  </div>
</template>

<script>
import TeamPlayers from "./TeamPlayers"
import axios from 'axios'

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
      },
      players: [],
      registeredPlayers: [],
      showTeamPlayersComponent: false
    }
  },
  created() {
    Promise.all([
      this.fetchAllPlayers(),
      this.fetchRegisteredPlayers()
    ]).then(() => {
      this.showTeamPlayersComponent = true
    })
  },
  components: {
    TeamPlayers
  },
  methods: {
    fetchRegisteredPlayers() {
      return axios.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    },
    fetchAllPlayers() {
      return axios.get('/api/v1/players').then(response => this.players = response.data)
    }
  }
}
</script>

<style scoped>
</style>

<style lang="scss" scoped>
/deep/ .el-collapse-item__header{
  font-size: 2rem;
  line-height: 40px;
  height: 72px;
}
</style>
