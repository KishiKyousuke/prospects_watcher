<template>
  <div id="app" class="row">
    <div class="col s12">
      <h4>チーム別選手一覧</h4>
    </div>
    <div class="col l6 s12">
      <h5 style="font-weight: bold">セ・リーグ</h5>
      <el-collapse v-model="activeNamesCentral">
        <el-collapse-item v-for="(team, i) in teams['central']" :key="team['name']" :title="team['formal_name']" :name="i">
          <team-players v-if="showTeamPlayersComponent" :selected-team="team['name']" :same-league-teams="teams['central']" :registered-players="registeredPlayers"></team-players>
        </el-collapse-item>
      </el-collapse>
    </div>
    <div class="col l6 s12">
      <h5 style="font-weight: bold">パ・リーグ</h5>
      <el-collapse v-model="activeNamesPacific">
        <el-collapse-item v-for="(team, i) in teams['pacific']" :key="team['name']" :title="team['formal_name']" :name="i">
          <team-players v-if="showTeamPlayersComponent" :selected-team="team['name']" :same-league-teams="teams['pacific']" :registered-players="registeredPlayers"></team-players>
        </el-collapse-item>
      </el-collapse>
    </div>
  </div>
</template>

<script>
import TeamPlayers from "./TeamPlayers"
import axios from 'axios'

export default {
  data: function () {
    return {
      activeNamesCentral: ['1'],
      activeNamesPacific: ['1'],
      teams: {},
      registeredPlayers: [],
      showTeamPlayersComponent: false,
      nowLoading: true
    }
  },
  created() {
    Promise.all([
      this.fetchAllPlayers(),
      this.fetchRegisteredPlayers()
    ]).then(() => {
      this.showTeamPlayersComponent = true
    })
  },
  components: {
    TeamPlayers
  },
  methods: {
    fetchRegisteredPlayers() {
      return axios.get('/api/v1/registered_players').then(response => this.registeredPlayers = response.data)
    },
    fetchAllPlayers() {
      return axios.get('/api/v1/players').then(response => this.teams = response.data)
    }
  }
}
</script>

<style scoped>
</style>

<style lang="scss" scoped>
/deep/ .el-collapse-item__header{
  font-size: 2rem;
  line-height: 40px;
  height: 72px;
}
</style>
