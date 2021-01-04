<template>
  <div id="app" class="row">
    <div class="col s12">
      <h5>野手</h5>
      <registered-batters :batters="registeredPlayers['batters']"></registered-batters>
    </div>
    <div class="col s12">
      <h5>投手</h5>
      <registered-pitchers :pitchers="registeredPlayers['pitchers']"></registered-pitchers>
    </div>
  </div>
</template>

<script>
import RegisteredBatters from './RegisteredBatters'
import RegisteredPitchers from './RegisteredPitchers'
import axios from 'axios'

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
      axios.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    }
  }
}
</script>
