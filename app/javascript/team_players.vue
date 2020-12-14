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
            width="90">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            width="180">
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
            width="90">
        </el-table-column>
        <el-table-column
            prop="name"
            label="名前"
            width="180">
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
