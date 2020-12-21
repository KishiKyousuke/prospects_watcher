<template>
  <div id="app">
    <el-button type="danger" size="mini" round @click="releaseProcessing" v-if="isRegistered">
      解除
    </el-button>
    <el-button type="success" size="mini" round @click="registerProcessing" v-else>
      登録
    </el-button>
  </div>
</template>

<script>
import { csrfToken } from '@rails/ujs'
import axios from 'axios'

axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
  data: function () {
    return {
      isRegistered: false
    }
  },
  props: {
    selectedPlayerId: {
      type: Number,
      require: true
    },
    playerType: {
      type: String,
      require: true
    },
    registeredPlayers: {
      type: Object,
      require: true
    }
  },
  mounted() {
    this.changeRegisteredValue()
  },
  methods: {
    registerProcessing(){
      this.registerPlayer()
      this.isRegistered = true
      this.successNotice()
    },
    registerPlayer: async function() {
      await axios.post(`/api/v1/favorite_${this.playerType}`, {player_id: this.selectedPlayerId})
    },
    successNotice() {
      this.$notify({
        title: '登録完了',
        message: '選手を登録しました',
        type: 'success'
      })
    },
    releaseProcessing() {
      this.releasePlayer()
      this.isRegistered = false
      this.deleteNotice()
    },
    releasePlayer: async function() {
      await axios.delete(`/api/v1/favorite_${this.playerType}`, {data: {player_id: this.selectedPlayerId}})
    },
    deleteNotice() {
      this.$notify({
        title: '登録解除',
        message: '選手を登録から解除しました',
        type: 'warning'
      })
    },
    changeRegisteredValue() {
      switch (this.playerType) {
        case 'batters':
          const registeredBattersId = this.registeredPlayers["batters"].map(player => player["batter_id"])
          this.isRegistered = registeredBattersId.includes(this.selectedPlayerId)
          break
        case 'pitchers':
          let registeredPitchersId = this.registeredPlayers["pitchers"].map(player => player["pitcher_id"])
          this.isRegistered = registeredPitchersId.includes(this.selectedPlayerId)
          break
      }
    }
  }
}
</script>

<style scoped>

</style>
