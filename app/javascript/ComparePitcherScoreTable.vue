<template>
  <v-container id="app">
    <v-btn icon fab small @click="closeModal()"><v-icon>mdi-close-circle</v-icon></v-btn>
    <table>
      <tr>
        <td :class="['player-name', playerX['english_team_name']]">{{playerX.name}}</td>
        <th>選手名</th>
        <td :class="['player-name', playerY['english_team_name']]">{{playerY.name}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerY['earned_run_average'], playerX['earned_run_average']) }">
          {{playerX['earned_run_average']}}
        </td>
        <th>防御率</th>
        <td :class="{ emphasis: isEmphasisFloat(playerX['earned_run_average'], playerY['earned_run_average']) }">
          {{playerY['earned_run_average']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['win'], playerY['win']) }">{{playerX['win']}}</td>
        <th>勝</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['win'], playerX['win']) }">{{playerY['win']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerY['lose'], playerX['lose']) }">{{playerX['lose']}}</td>
        <th>負</th>
        <td :class="{ emphasis: isEmphasisInt(playerX['lose'], playerY['lose']) }">{{playerY['lose']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['innings_pitched'], playerY['innings_pitched']) }">
          {{playerX['innings_pitched']}}
        </td>
        <th>投球回</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['innings_pitched'], playerX['innings_pitched']) }">
          {{playerY['innings_pitched']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['pitched'], playerY['pitched']) }">{{playerX['pitched']}}</td>
        <th>登板</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['pitched'], playerX['pitched']) }">{{playerY['pitched']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['number_of_save'], playerY['number_of_save']) }">
          {{playerX['number_of_save']}}
        </td>
        <th>セーブ</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['number_of_save'], playerX['number_of_save']) }">
          {{playerY['number_of_save']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['hold_point'], playerY['hold_point']) }">{{playerX['hold_point']}}</td>
        <th>HP</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['hold_point'], playerX['hold_point']) }">{{playerY['hold_point']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['strikeout'], playerY['strikeout']) }">{{playerX['strikeout']}}</td>
        <th>三振</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['strikeout'], playerX['strikeout']) }">{{playerY['strikeout']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['strikeouts_per_nine_innings'], playerY['strikeouts_per_nine_innings']) }">
          {{playerX['strikeouts_per_nine_innings']}}
        </td>
        <th>奪三振率</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['strikeouts_per_nine_innings'], playerX['strikeouts_per_nine_innings']) }">
          {{playerY['strikeouts_per_nine_innings']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerY['base_on_balls'], playerX['base_on_balls']) }">
          {{playerX['base_on_balls']}}
        </td>
        <th>四球</th>
        <td :class="{ emphasis: isEmphasisInt(playerX['base_on_balls'], playerY['base_on_balls']) }">
          {{playerY['base_on_balls']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerY['hit_by_pitch'], playerX['hit_by_pitch']) }">
          {{playerX['hit_by_pitch']}}
        </td>
        <th>死球</th>
        <td :class="{ emphasis: isEmphasisInt(playerX['hit_by_pitch'], playerY['hit_by_pitch']) }">
          {{playerY['hit_by_pitch']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['strikeout_to_walk_ratio'], playerY['strikeout_to_walk_ratio']) }">
          {{playerX['strikeout_to_walk_ratio']}}
        </td>
        <th>K/BB</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['strikeout_to_walk_ratio'], playerX['strikeout_to_walk_ratio']) }">
          {{playerY['strikeout_to_walk_ratio']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerY['walks_and_hits_per_innings_pitched'], playerX['walks_and_hits_per_innings_pitched']) }">
          {{playerX['walks_and_hits_per_innings_pitched']}}
        </td>
        <th>WHIP</th>
        <td :class="{ emphasis: isEmphasisFloat(playerX['walks_and_hits_per_innings_pitched'], playerY['walks_and_hits_per_innings_pitched']) }">
          {{playerY['walks_and_hits_per_innings_pitched']}}
        </td>
      </tr>
    </table>
  </v-container>
</template>

<script>
export default {
  props: {
    checkedPlayers: {
      type: Array,
      require: true
    }
  },
  data: function () {
    return {
      playerX: null,
      playerY: null
    }
  },
  mounted() {
    [this.playerY, this.playerX] = this.checkedPlayers
  },
  methods: {
    closeModal() {
      this.$emit('close-modal')
    },
    isEmphasisInt(playerScoreBefore, playerScoreAfter) {
      return parseInt(playerScoreBefore) >= parseInt(playerScoreAfter)
    },
    isEmphasisFloat(playerScoreBefore, playerScoreAfter) {
      return parseFloat(playerScoreBefore) >= parseFloat(playerScoreAfter)
    }
  }
}
</script>

<style scoped>
.v-container {
  position: relative;
}

table {
  width: 80%;
  margin: auto;
  border: 1px solid #dcdfe6;
  border-collapse: collapse;
}

table th {
  color: #606266;
  vertical-align: bottom;
  border-bottom: 1px solid #dcdfe6;
  background: linear-gradient(#f4f5f8,#f1f3f6);
  padding: 10px 0;
  text-align: center;
}

table td {
  padding: 10px 0;
  text-align: center;
  width: 35%;
}

.player-name {
  font-weight: bold;
  font-size: 1.2rem;
  background: linear-gradient(#f4f5f8,#f1f3f6);
}

.v-btn {
  position: absolute;
  top: 0;
  right: 0;
}

.emphasis {
  font-weight: bold;
  color: red;
}

.hawks {
  content: '';
  border-bottom: thick solid #FEA409;
  padding-bottom: 4px;
}

.marines {
  content: '';
  border-bottom: thick solid #6E6E6E;
  padding-bottom: 4px;
}

.lions {
  content: '';
  border-bottom: thick solid #192546;
  padding-bottom: 4px;
}

.eagles {
  content: '';
  border-bottom: thick solid #7F001E;
  padding-bottom: 4px;
}

.fighters {
  content: '';
  border-bottom: thick solid #285A8A;
  padding-bottom: 4px;
}

.buffaloes {
  content: '';
  border-bottom: thick solid #34328A;
  padding-bottom: 4px;
}

.giants {
  content: '';
  border-bottom: thick solid #E96D06;
  padding-bottom: 4px;
}

.tigers {
  content: '';
  border-bottom: thick solid #FED80C;
  padding-bottom: 4px;
}

.dragons {
  content: '';
  border-bottom: thick solid #113C7C;
  padding-bottom: 4px;
}

.baystars {
  content: '';
  border-bottom: thick solid #1182D8;
  padding-bottom: 4px;
}

.carp {
  content: '';
  border-bottom: thick solid #C70019;
  padding-bottom: 4px;
}

.swallows {
  content: '';
  border-bottom: thick solid #1A753E;
  padding-bottom: 4px;
}
</style>
