<template>
  <v-row id="app">
    <v-col cols="6">
      <div class="center">
        <h5>野手</h5>
      </div>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th>背番号</th>
              <th>名前</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="player in teamBatters[0]" :key="player.id">
              <td>{{ player.number }}</td>
              <td>{{ player.name }}</td>
              <td>
                <register-button :selected-player-id="player.id" :player-type="'batters'" :registered-players="registeredPlayers"></register-button>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-col>
    <v-col cols="6">
      <div class="center">
        <h5>投手</h5>
      </div>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th>背番号</th>
              <th>名前</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="player in teamPitchers[0]" :key="player.id">
              <td>{{ player.number }}</td>
              <td>{{ player.name }}</td>
              <td>
                <register-button :selected-player-id="player.id" :player-type="'pitchers'" :registered-players="registeredPlayers"></register-button>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-col>
  </v-row>
</template>

<script>
import RegisterButton from './RegisterButton'

export default {
  data: function () {
    return {
      teamBatters: [],
      teamPitchers: []
    }
  },
  props: {
    selectedTeam: {
      type: String,
      require: true
    },
    sameLeagueTeams: {
      type: Array,
      require: true
    },
    registeredPlayers: {
      type: Object,
      require: true
    }
  },
  mounted() {
    this.teamBatters.push(this.divideTeam('batters'))
    this.teamPitchers.push(this.divideTeam('pitchers'))
  },
  methods: {
    divideTeam(playersType) {
      return this.sameLeagueTeams.find(element => element.name === this.selectedTeam)[`${playersType}`]
    }
  },
  components: {
    RegisterButton
  }
}
</script>

<style scoped>
h5 {
  padding: 8px 0;
  font-weight: bold;
  font-family: Helvetica,Arial,'メイリオ','ヒラギノ W','Hiragino Sans','ヒラギノ角ゴシック','ＭＳ Ｐゴシック',sans-serif;;
}

th {
  font-size: 1rem;
}
td {
  font-size: 1.3rem;
  padding: 4px 0;
}
</style>
