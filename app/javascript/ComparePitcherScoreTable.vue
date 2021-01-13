<template>
  <v-container id="app">
    <h4>選手比較</h4>
    <table>
      <tr>
        <td>{{playerX.name}}</td><th>選手名</th><td>{{playerY.name}}</td>
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
    [this.playerX, this.playerY] = this.checkedPlayers
  },
  methods: {
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
table > tr > td,th {
  text-align: center;
}

.emphasis {
  font-weight: bold;
  color: red;
}
</style>
