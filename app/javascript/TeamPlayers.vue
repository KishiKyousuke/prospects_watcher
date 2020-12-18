<template>
  <div id="app">
    <div class="col s6">
      <h5>野手</h5>
      <el-table
          :data="teamBatters[0]"
          style="width: 100%"
      >
        <el-table-column
            prop="number"
            label="背番号"
            min-width="70">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            min-width="170">
        </el-table-column>
        <el-table-column
            min-width="80">
          <template slot-scope="scope">
            <register-button :selected-player-id="scope.row.id" :player-type="'batters'" :registered-players="registeredPlayers"></register-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="col s6">
      <h5>投手</h5>
      <el-table
          :data="teamPitchers[0]"
          style="width: 100%">
        <el-table-column
            prop="number"
            label="背番号"
            min-width="70">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            min-width="170">
        </el-table-column>
        <el-table-column
            min-width="80">
          <template slot-scope="scope">
            <register-button :selected-player-id="scope.row.id" :player-type="'pitchers'" :registered-players="registeredPlayers"></register-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import RegisterButton from "./RegisterButton"

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
    players: {
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
      return this.players.find(element => element.name === this.selectedTeam)[`${playersType}`]
    }
  },
  components: {
    RegisterButton
  }
}
</script>

<style scoped>
</style>
