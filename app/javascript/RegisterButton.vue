<template>
  <div id="app" class="pl-8">
    <v-btn class="white--text" rounded small color="red" elevation="3" @click="releaseProcessing" v-if="isRegistered" :disabled="active">
      <v-icon>
        mdi-minus
      </v-icon>
    </v-btn>
    <v-btn class="white--text" rounded small color="light-green" elevation="3" @click="registerProcessing" v-else :disabled="active">
      <v-icon>
        mdi-plus
      </v-icon>
    </v-btn>
  </div>
</template>

<script>
import {axiosClient} from './axios_client'

export default {
  data: function () {
    return {
      isRegistered: false,
      active: false
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
      this.active = true
      this.registerPlayer().then(() => {
        this.successNotice()
      }).catch(() => {
        this.duplicateErrorNotice()
      }).finally(() => {
        this.isRegistered = true
        this.active = false
      })
    },
    registerPlayer: async function() {
      return await axiosClient.post(`/api/v1/favorite_${this.playerType}`, {player_id: this.selectedPlayerId})
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
    },
    releaseProcessing() {
      this.active = true
      this.releasePlayer().then(() => {
        this.releaseNotice()
      }).finally(() => {
        this.isRegistered = false
        this.active = false
      })
    },
    releasePlayer: async function() {
      await axiosClient.delete(`/api/v1/favorite_${this.playerType}`, {data: {player_id: this.selectedPlayerId}})
    },
    releaseNotice() {
      this.$notify({
        title: '登録解除',
        message: '選手を登録から解除しました',
        type: 'warning'
      })
    },
    changeRegisteredValue() {
      switch (this.playerType) {
        case 'batters':
          const registeredBattersId = this.registeredPlayers['batters'].map(player => player['batter_id'])
          this.isRegistered = registeredBattersId.includes(this.selectedPlayerId)
          break
        case 'pitchers':
          let registeredPitchersId = this.registeredPlayers['pitchers'].map(player => player['pitcher_id'])
          this.isRegistered = registeredPitchersId.includes(this.selectedPlayerId)
          break
      }
    }
  }
}
</script>

<style scoped>
.pl-8 {
  padding-left: 8px;
}
</style>
