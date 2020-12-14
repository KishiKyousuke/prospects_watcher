<template>
  <div id="app">
    <el-button type="success" size="mini" round @click="registerProcessing">
      登録
    </el-button>
  </div>
</template>

<script>
import { csrfToken } from 'rails-ujs'
import axios from 'axios'

axios.defaults.headers.common['X-CSRF-TOKEN'] = csrfToken()

export default {
  data: function () {
    return {
    }
  },
  props: ["selectedPlayer", "playerType"],
  methods: {
    registerProcessing(){
      this.registerPlayer()
      this.successNotice()
    },
    registerPlayer: async function() {
      await axios.post(`/api/v1/favorite_${this.playerType}`, { player_id: this.selectedPlayer })
    },
    successNotice() {
      this.$notify({
        title: '登録完了',
        message: '選手を登録しました',
        type: 'success'
      })
    }
  }
}
</script>

<style scoped>

</style>
