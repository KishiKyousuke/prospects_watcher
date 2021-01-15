<template>
  <v-app id="app">
    <v-container>
      <h5 class="center">チームから探す</h5>
      <v-tabs v-model="tab" :grow="true" :slider-size="5" height="60px">
        <v-tab class="central-tab" @click="tabsSliderColor = '#14A26F'">セ・リーグ</v-tab>
        <v-tab class="pacific-tab" @click="tabsSliderColor = '#30A6CC'">パ・リーグ</v-tab>
        <v-tabs-slider :color="changeColor" />
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <v-row>
            <v-expansion-panels focusable>
              <v-expansion-panel v-for="team in teams['central']" :key="team['name']">
                <v-expansion-panel-header>
                  <v-img :src="displayTeamLogo(team['english_team_name'])" max-width="64px"></v-img>
                  <span>{{team['formal_name']}}</span>
                </v-expansion-panel-header>
                <v-expansion-panel-content>
                  <team-players v-if="showTeamPlayersComponent" :selected-team="team['name']" :same-league-teams="teams['central']" :registered-players="registeredPlayers"></team-players>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-row>
        </v-tab-item>
        <v-tab-item>
          <v-row>
            <v-expansion-panels focusable>
              <v-expansion-panel v-for="team in teams['pacific']" :key="team['name']">
                <v-expansion-panel-header>
                  <v-img :src="displayTeamLogo(team['english_team_name'])" max-width="64px"></v-img>
                  <span>{{team['formal_name']}}</span>
                </v-expansion-panel-header>
                <v-expansion-panel-content>
                  <team-players v-if="showTeamPlayersComponent" :selected-team="team['name']" :same-league-teams="teams['pacific']" :registered-players="registeredPlayers"></team-players>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-row>
        </v-tab-item>
      </v-tabs-items>
    </v-container>
  </v-app>
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
      tab: null,
      tabsSliderColor: '#14A26F'
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
  computed: {
    changeColor() {
      return this.tabsSliderColor
    }
  },
  methods: {
    fetchRegisteredPlayers() {
      return axiosClient.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    },
    fetchAllPlayers() {
      return axiosClient.get('/api/v1/players').then(response => this.teams = response.data)
    },
    displayTeamLogo(team_name) {
      return `team_logo/${team_name}_logo.png`
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

.v-window {
  margin: 24px 0;
  overflow: initial;
}

.v-tab {
  font-size: 1.3rem;
  font-weight: bold;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
}

.central-tab {
  color: #14A26F;
}

.pacific-tab {
  color: #30A6CC;
}

h5 {
  font-weight: bold;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
}
</style>
