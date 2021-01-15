<template>
  <v-row id="app">
    <v-col cols="6">
      <div class="center">
        <h5>野手</h5>
      </div>
      <el-table
          :data="teamBatters[0]"
          style="width: 100%"
      >
        <el-table-column
            prop="number"
            label="背番号"
            min-width="72">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            min-width="168">
        </el-table-column>
        <el-table-column
            min-width="80">
          <template slot-scope="scope">
            <register-button :selected-player-id="scope.row.id" :player-type="'batters'" :registered-players="registeredPlayers"></register-button>
          </template>
        </el-table-column>
      </el-table>
    </v-col>
    <v-col cols="6">
      <div class="center">
        <h5>投手</h5>
      </div>
      <el-table
          :data="teamPitchers[0]"
          style="width: 100%">
        <el-table-column
            prop="number"
            label="背番号"
            min-width="72">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            min-width="168">
        </el-table-column>
        <el-table-column
            min-width="80">
          <template slot-scope="scope">
            <register-button :selected-player-id="scope.row.id" :player-type="'pitchers'" :registered-players="registeredPlayers"></register-button>
          </template>
        </el-table-column>
      </el-table>
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

/deep/ .el-table th>.cell {
  font-size: 1rem;
}
/deep/ .el-table td>.cell {
  font-size: 1.3rem;
  padding: 4px 0;
}
</style>
