<template>
  <v-app>
    <v-snackbar v-model="snackbar">ログインしました</v-snackbar>
    <v-container :fluid="true" id="app">
      <h5 class="center">登録済み選手一覧</h5>
      <v-tabs v-model="tab" :grow="true">
        <v-tab>野手</v-tab>
        <v-tab>投手</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <blank-page v-if="registeredPlayers['batters'].length === 0"></blank-page>
          <registered-batters v-else :batters="registeredPlayers['batters']"></registered-batters>
        </v-tab-item>
        <v-tab-item>
          <blank-page v-if="registeredPlayers['pitchers'].length === 0"></blank-page>
          <registered-pitchers v-else :pitchers="registeredPlayers['pitchers']"></registered-pitchers>
        </v-tab-item>
      </v-tabs-items>
    </v-container>
  </v-app>
</template>

<script>
import RegisteredBatters from './RegisteredBatters'
import RegisteredPitchers from './RegisteredPitchers'
import BlankPage from './BlankPage'
import {axiosClient} from './axios_client'

export default {
  data: function () {
    return {
      registeredPlayers: {},
      tab: null,
      snackbar: false
    }
  },
  components: {
    RegisteredBatters,
    RegisteredPitchers,
    BlankPage
  },
  created() {
    this.fetchRegisteredPlayers()
  },
  mounted() {
    const paths = ['/users/sign_in', '/users/sign_up']
    if (paths.find((path) => document.referrer.includes(path))) {
      this.snackbar = true
    }
  },
  methods: {
    fetchRegisteredPlayers() {
      axiosClient.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    }
  }
}
</script>

<style scoped>
/deep/ .v-application--wrap {
  min-height: initial;
  min-height: auto;
}

.v-tab {
  font-size: 1.4rem;
  font-weight: bold;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
}

h5 {
  font-weight: bold;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
}
</style>
