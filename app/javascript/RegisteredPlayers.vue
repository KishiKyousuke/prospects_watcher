<template>
  <v-container :fluid="true" id="app">
    <div>
      <h5>野手</h5>
      <registered-batters :batters="registeredPlayers['batters']"></registered-batters>
    </div>
    <div>
      <h5>投手</h5>
      <registered-pitchers :pitchers="registeredPlayers['pitchers']"></registered-pitchers>
    </div>
  </v-container>
</template>

<script>
import RegisteredBatters from './RegisteredBatters'
import RegisteredPitchers from './RegisteredPitchers'
import {axiosClient} from './axios_client'

export default {
  data: function () {
    return {
      registeredPlayers: {}
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
