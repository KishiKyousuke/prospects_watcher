<template>
  <div class="row">
    <div class="col s12" id="search-field-title">
      <h4>選手名検索</h4>
      <hr>
    </div>
    <div class="col s6 center m-auto float-none">
      <vue-simple-suggest
        v-model="selected"
        :list="players"
        display-attribute="name"
        value-attribute="id"
        mode="select"
        :filter-by-query="true"
        :styles="autoCompleteStyles"
        class="col s8">
        <template slot="suggestion-item" slot-scope="{ suggestion }">
          <span>{{ suggestion.name }}</span>
        </template>
      </vue-simple-suggest>
      <el-button type="success" @click="registerProcessing" round class="col s2">登録</el-button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import VueSimpleSuggest from 'vue-simple-suggest'

export default {
  data() {
    return {
      teams: [],
      players: [],
      selected: {},
      autoCompleteStyles: {
        suggestItem: "left-align"
      }
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
      return axios.get('/api/v1/players').then(response => this.teams = response.data)
    },
    disassembleTeams(league) {
      const teams = this.teams[`${league}`]
      for (let dividedTeam of teams) {
        const batters = dividedTeam['batters'].map(batter => ({...batter, playerType: "batters"}))
        this.players.push(batters)
        const pitchers = dividedTeam['pitchers'].map(pitcher => ({...pitcher, playerType: "pitchers"}))
        this.players.push(pitchers)
      }
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
      return await axios.post(`/api/v1/favorite_${this.selected['playerType']}`, {player_id: this.selected['id']})
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
.m-auto {
  margin: auto;
}

.float-none {
  float: none;
}

#search-field-title{
  margin-bottom: 40px;
}
</style>
