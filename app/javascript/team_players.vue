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
          <template slot-scope="scope">
            <registerButton :selected-player-id="scope.row.id" :player-type="'batters'" :registered-players="registeredPlayers"></registerButton>
          </template>
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
          <template slot-scope="scope">
            <registerButton :selected-player-id="scope.row.id" :player-type="'pitchers'" :registered-players="registeredPlayers"></registerButton>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import RegisterButton from "./register_button"

export default {
  props: ["selectedTeam", "players", "registeredPlayers"]
  ,
  components: {
    RegisterButton
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
