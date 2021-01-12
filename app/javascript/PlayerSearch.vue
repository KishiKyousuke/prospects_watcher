<template>
  <div id="app">
    <v-container>
      <v-row>
        <v-col>
          <vue-simple-suggest
              placeholder="選手名で登録"
              v-model="selected"
              :list="players"
              display-attribute="name"
              value-attribute="id"
              mode="select"
              :filter-by-query="true">
            <template slot="suggestion-item" slot-scope="{ suggestion }">
              <span>{{ suggestion.name }}</span>
            </template>
          </vue-simple-suggest>
        </v-col>
        <v-col>
          <el-button type="success" size="small" @click="registerProcessing" round>登録</el-button>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import {axiosClient} from './axios_client'
import VueSimpleSuggest from 'vue-simple-suggest'

export default {
  data() {
    return {
      teams: [],
      players: [],
      selected: {},
    }
  },
  components: {
    VueSimpleSuggest
  },
  created() {
    Promise.all([
      this.fetchAllTeams()
    ]).then(() => {
      this.disassembleTeams('central')
      this.disassembleTeams('pacific')
      this.players = this.players.flat()
    })
  },
  methods: {
    fetchAllTeams() {
      return axiosClient.get('/api/v1/players').then(response => this.teams = response.data)
    },
    disassembleTeams(league) {
      const teams = this.teams[`${league}`]
      for (let dividedTeam of teams) {
        this.players.push(this.addPlayerTypeProperty(dividedTeam['batters'], 'batters'))
        this.players.push(this.addPlayerTypeProperty(dividedTeam['pitchers'], 'pitchers'))
      }
    },
    addPlayerTypeProperty(players, playerType) {
      return players.map(player => ({...player, playerType: `${playerType}`}))
    },
    registerProcessing(){
      this.registerPlayer().then(() => {
        this.successNotice()
      }).catch(() => {
        this.duplicateErrorNotice()
      }).finally(() => {
        this.selected = ''
      })
    },
    registerPlayer: async function() {
      return await axiosClient.post(`/api/v1/favorite_${this.selected['playerType']}`, {player_id: this.selected['id']})
    },
    successNotice() {
      this.$notify({
        title: '登録完了',
        message: '選手を登録しました',
        type: 'success'
      })
    },
    duplicateErrorNotice() {
      this.$notify({
        title: '登録エラー',
        message: 'この選手は既に登録されています',
        type: 'error'
      })
    }
  }
}
</script>

<style scoped>
div.col {
  padding: 0 8px;
}

/deep/ .vue-simple-suggest.designed {
  width: 264px;
  padding: 0;
  margin-top: 12px;
}

/deep/ .input-wrapper input {
  height: 40px;
}

/deep/ .suggest-item {
  float: none;
  line-height: 32px;
}
</style>
