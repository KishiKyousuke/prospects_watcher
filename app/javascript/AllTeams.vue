<template>
  <div id="app">
    <h4>チーム別選手一覧</h4>
    <v-container>
      <h5 style="font-weight: bold;">セ・リーグ</h5>
      <v-row>
        <v-expansion-panels popout>
          <v-expansion-panel v-for="(team, i) in teams['central']" :key="i">
            <v-expansion-panel-header>
              <v-img :src="displayTeamLogo(team['name'])" max-width="64px"></v-img>
              <span>{{team['formal_name']}}</span>
            </v-expansion-panel-header>
            <v-expansion-panel-content>
              <team-players v-if="showTeamPlayersComponent" :selected-team="team['name']" :same-league-teams="teams['central']" :registered-players="registeredPlayers"></team-players>
            </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>
      </v-row>
      <h5 style="font-weight: bold">パ・リーグ</h5>
      <v-row>
        <v-expansion-panels popout>
          <v-expansion-panel v-for="team in teams['pacific']" :key="team['name']">
            <v-expansion-panel-header>
              <v-img :src="displayTeamLogo(team['name'])" max-width="64px"></v-img>
              <span>{{team['formal_name']}}</span>
            </v-expansion-panel-header>
            <v-expansion-panel-content>
              <team-players v-if="showTeamPlayersComponent" :selected-team="team['name']" :same-league-teams="teams['pacific']" :registered-players="registeredPlayers"></team-players>
            </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import TeamPlayers from './TeamPlayers'
import {axiosClient} from './axios_client'

export default {
  data: function () {
    return {
      teams: {},
      registeredPlayers: [],
      showTeamPlayersComponent: false,
      teamLogos: {
        'ソフトバンク': 'hawks_logo.png',
        'ロッテ': 'marines_logo.png',
        '西武': 'lions_logo.png',
        '楽天': 'eagles_logo.png',
        '日本ハム': 'fighters_logo.png',
        'オリックス': 'buffaloes_logo.png',
        '巨人': 'giants_logo.png',
        '阪神': 'tigers_logo.png',
        '中日': 'dragons_logo.png',
        'DeNA': 'baystars_logo.png',
        '広島': 'carp_logo.png',
        'ヤクルト': 'swallows_logo.png'
      }
    }
  },
  created() {
    Promise.all([
      this.fetchAllPlayers(),
      this.fetchRegisteredPlayers()
    ]).then(() => {
      this.loading = false
      this.showTeamPlayersComponent = true
    })
  },
  components: {
    TeamPlayers
  },
  methods: {
    fetchRegisteredPlayers() {
      return axiosClient.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    },
    fetchAllPlayers() {
      return axiosClient.get('/api/v1/players').then(response => this.teams = response.data)
    },
    displayTeamLogo(team_name) {
      return 'team_logo/' + this.teamLogos[team_name]
    }
  }
}
</script>

<style scoped>
span{
  font-size: 1.5em;
  font-weight: bold;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
  text-align: left;
  margin-left: 24px;
}
</style>
