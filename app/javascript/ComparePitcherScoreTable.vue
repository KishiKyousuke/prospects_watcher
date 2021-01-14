<template>
  <v-container id="app">
    <v-btn icon fab small @click="closeModal()"><v-icon>mdi-close-circle</v-icon></v-btn>
    <table>
      <tr>
        <td :class="['player-name', playerX['english_team_name']]">{{playerX.name}}</td><th>選手名</th><td :class="['player-name', playerY['english_team_name']]">{{playerY.name}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: earnedRunAverageX() }">{{playerX['earned_run_average']}}</td><th>防御率</th><td :class="{ emphasis: earnedRunAverageY() }">{{playerY['earned_run_average']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: winX() }">{{playerX['win']}}</td><th>勝</th><td :class="{ emphasis: winY() }">{{playerY['win']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: loseX() }">{{playerX['lose']}}</td><th>負</th><td :class="{ emphasis: loseY() }">{{playerY['lose']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: inningsPitchedX() }">{{playerX['innings_pitched']}}</td><th>投球回</th><td :class="{ emphasis: inningsPitchedY() }">{{playerY['innings_pitched']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: pitchedX() }">{{playerX['pitched']}}</td><th>登板</th><td :class="{ emphasis: pitchedY() }">{{playerY['pitched']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: numberOfSaveX() }">{{playerX['number_of_save']}}</td><th>セーブ</th><td :class="{ emphasis: numberOfSaveY() }">{{playerY['number_of_save']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: holdPointX() }">{{playerX['hold_point']}}</td><th>HP</th><td :class="{ emphasis: holdPointY() }">{{playerY['hold_point']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: strikeoutX() }">{{playerX['strikeout']}}</td><th>三振</th><td :class="{ emphasis: strikeoutY() }">{{playerY['strikeout']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: strikeoutsPerNineInningsX() }">{{playerX['strikeouts_per_nine_innings']}}</td><th>奪三振率</th><td :class="{ emphasis: strikeoutsPerNineInningsY() }">{{playerY['strikeouts_per_nine_innings']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: strikeoutToWalkRatioX() }">{{playerX['strikeout_to_walk_ratio']}}</td><th>K/BB</th><td :class="{ emphasis: strikeoutToWalkRatioY() }">{{playerY['strikeout_to_walk_ratio']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: walksAndHitsPerInningsPitchedX() }">{{playerX['walks_and_hits_per_innings_pitched']}}</td><th>WHIP</th><td :class="{ emphasis: walksAndHitsPerInningsPitchedY() }">{{playerY['walks_and_hits_per_innings_pitched']}}</td>
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
    earnedRunAverageX() {
      return parseFloat(this.playerX['earned_run_average']) <= parseFloat(this.playerY['earned_run_average'])
    },
    earnedRunAverageY() {
      return parseFloat(this.playerX['earned_run_average']) >= parseFloat(this.playerY['earned_run_average'])
    },
    winX() {
      return parseInt(this.playerX['win']) >= parseInt(this.playerY['win'])
    },
    winY() {
      return parseInt(this.playerX['win']) <= parseInt(this.playerY['win'])
    },
    loseX() {
      return parseFloat(this.playerX['lose']) <= parseFloat(this.playerY['lose'])
    },
    loseY() {
      return parseFloat(this.playerX['lose']) >= parseFloat(this.playerY['lose'])
    },
    inningsPitchedX() {
      return parseFloat(this.playerX['innings_pitched']) >= parseFloat(this.playerY['innings_pitched'])
    },
    inningsPitchedY() {
      return parseFloat(this.playerX['innings_pitched']) <= parseFloat(this.playerY['innings_pitched'])
    },
    pitchedX() {
      return parseInt(this.playerX['pitched']) >= parseInt(this.playerY['pitched'])
    },
    pitchedY() {
      return parseInt(this.playerX['pitched']) <= parseInt(this.playerY['pitched'])
    },
    numberOfSaveX() {
      return parseInt(this.playerX['number_of_save']) >= parseInt(this.playerY['number_of_save'])
    },
    numberOfSaveY() {
      return parseInt(this.playerX['number_of_save']) <= parseInt(this.playerY['number_of_save'])
    },
    holdPointX() {
      return parseInt(this.playerX['hold_point']) >= parseInt(this.playerY['hold_point'])
    },
    holdPointY() {
      return parseInt(this.playerX['hold_point']) <= parseInt(this.playerY['hold_point'])
    },
    strikeoutX() {
      return parseInt(this.playerX['strikeout']) >= parseInt(this.playerY['strikeout'])
    },
    strikeoutY() {
      return parseInt(this.playerX['strikeout']) <= parseInt(this.playerY['strikeout'])
    },
    strikeoutsPerNineInningsX() {
      return parseFloat(this.playerX['strikeouts_per_nine_innings']) >= parseFloat(this.playerY['strikeouts_per_nine_innings'])
    },
    strikeoutsPerNineInningsY() {
      return parseFloat(this.playerX['strikeouts_per_nine_innings']) <= parseFloat(this.playerY['strikeouts_per_nine_innings'])
    },
    strikeoutToWalkRatioX() {
      return parseFloat(this.playerX['strikeout_to_walk_ratio']) >= parseFloat(this.playerY['strikeout_to_walk_ratio'])
    },
    strikeoutToWalkRatioY() {
      return parseFloat(this.playerX['strikeout_to_walk_ratio']) <= parseFloat(this.playerY['strikeout_to_walk_ratio'])
    },
    walksAndHitsPerInningsPitchedX() {
      return parseFloat(this.playerX['walks_and_hits_per_innings_pitched']) <= parseFloat(this.playerY['walks_and_hits_per_innings_pitched'])
    },
    walksAndHitsPerInningsPitchedY() {
      return parseFloat(this.playerX['walks_and_hits_per_innings_pitched']) >= parseFloat(this.playerY['walks_and_hits_per_innings_pitched'])
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
  border-collapse: collapse
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
