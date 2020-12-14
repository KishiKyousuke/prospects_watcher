<template>
  <div id="app" class="container">
    <div class="batters-box">
      <h3>野手</h3>
      <el-table
          :data="players[selectedTeam]['batters']"
          style="width: 100%">
        <el-table-column
            prop="number"
            label="背番号"
            width="70">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            width="170">
        </el-table-column>
        <el-table-column
            width="80">
          <el-button
              type="success"
              size="mini"
              round
              @click="open1">
            登録
          </el-button>
        </el-table-column>
      </el-table>
    </div>
    <div class="pitchers-box">
      <h3>投手</h3>
      <el-table
          :data="players[selectedTeam]['pitchers']"
          style="width: 100%">
        <el-table-column
            prop="number"
            label="背番号"
            width="70">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            width="170">
        </el-table-column>
        <el-table-column
            width="80">
          <el-button
              type="success"
              size="mini"
              round
              @click="open1">
            登録
          </el-button>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import axios from "axios"

export default {
  data: function () {
    return {
      players: []
    }
  },
  props: ["selectedTeam"]
  ,
  mounted() {
    axios.get('/api/v1/players').then(response => this.players = response.data)
  },
  methods: {
    open1() {
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
.container {
  display: flex;
}

.batters-box, .pitchers-box {
  width: 350px;
}
</style>
