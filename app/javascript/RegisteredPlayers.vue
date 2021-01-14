<template>
  <v-app>
    <v-container :fluid="true" id="app">
      <h5 class="center">登録済み選手一覧</h5>
      <v-tabs v-model="tab" :grow="true">
        <v-tab>野手</v-tab>
        <v-tab>投手</v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item>
          <registered-batters :batters="registeredPlayers['batters']"></registered-batters>
        </v-tab-item>
        <v-tab-item>
          <registered-pitchers :pitchers="registeredPlayers['pitchers']"></registered-pitchers>
        </v-tab-item>
      </v-tabs-items>
    </v-container>
  </v-app>
</template>

<script>
import RegisteredBatters from './RegisteredBatters'
import RegisteredPitchers from './RegisteredPitchers'
import {axiosClient} from './axios_client'

export default {
  data: function () {
    return {
      registeredPlayers: {},
      tab: null
    }
  },
  components: {
    RegisteredBatters,
    RegisteredPitchers
  },
  created() {
    this.fetchRegisteredPlayers()
  },
  methods: {
    fetchRegisteredPlayers() {
      axiosClient.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    }
  }
}
</script>

<style scoped>
.v-tab {
  font-size: 1.4rem;
  font-weight: bold;
}

h5 {
  font-weight: bold;
  font-family: Helvetica,Arial,"メイリオ","ヒラギノ W3","Hiragino Sans","ヒラギノ角ゴシック","ＭＳ Ｐゴシック",sans-serif;
}
</style>
