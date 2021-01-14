<template>
  <v-container id="app">
    <v-btn icon fab small @click="closeModal()"><v-icon>mdi-close-circle</v-icon></v-btn>
    <table>
      <tr>
        <td :class="['player-name', playerX['english_team_name']]">{{playerX.name}}</td><th>選手名</th><td :class="['player-name', playerY['english_team_name']]">{{playerY.name}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: atBatX() }">{{playerX['at_bat']}}</td><th>打数</th><td :class="{ emphasis: atBatY() }">{{playerY['at_bat']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: hitsX() }">{{playerX['hits']}}</td><th>安打</th><td :class="{ emphasis: hitsY() }">{{playerY['hits']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: battingAverageX() }">{{playerX['batting_average']}}</td><th>打率</th><td :class="{ emphasis: battingAverageY() }">{{playerY['batting_average']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: homeRunX() }">{{playerX['home_run']}}</td><th>HR</th><td :class="{ emphasis: homeRunY() }">{{playerY['home_run']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: runsBattedInX() }">{{playerX['runs_batted_in']}}</td><th>打点</th><td :class="{ emphasis: runsBattedInY() }">{{playerY['runs_batted_in']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: stolenBaseX() }">{{playerX['stolen_base']}}</td><th>盗塁</th><td :class="{ emphasis: stolenBaseY() }">{{playerY['stolen_base']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: onBasePercentageX() }">{{playerX['on_base_percentage']}}</td><th>出塁率</th><td :class="{ emphasis: onBasePercentageY() }">{{playerY['on_base_percentage']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: onBasePlusSluggingX() }">{{playerX['on_base_plus_slugging']}}</td><th>OPS</th><td :class="{ emphasis: onBasePlusSluggingY() }">{{playerY['on_base_plus_slugging']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: walksX() }">{{playerX['walks']}}</td><th>四球</th><td :class="{ emphasis: walksY() }">{{playerY['walks']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: hitByPitchX() }">{{playerX['hit_by_pitch']}}</td><th>死球</th><td :class="{ emphasis: hitByPitchY() }">{{playerY['hit_by_pitch']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: scoringPositionBattingAverageX() }">{{playerX['scoring_position_batting_average']}}</td><th>得点圏</th><td :class="{ emphasis: scoringPositionBattingAverageY() }">{{playerY['scoring_position_batting_average']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: strikeoutX() }">{{playerX['strikeout']}}</td><th>三振</th><td :class="{ emphasis: strikeoutY() }">{{playerY['strikeout']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: errorX() }">{{playerX['error']}}</td><th>失策</th><td :class="{ emphasis: errorY() }">{{playerY['error']}}</td>
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
    atBatX() {
      return parseInt(this.playerX['at_bat']) >= parseInt(this.playerY['at_bat'])
    },
    atBatY() {
      return parseInt(this.playerX['at_bat']) <= parseInt(this.playerY['at_bat'])
    },
    hitsX() {
      return parseInt(this.playerX['hits']) >= parseInt(this.playerY['hits'])
    },
    hitsY() {
      return parseInt(this.playerX['hits']) <= parseInt(this.playerY['hits'])
    },
    battingAverageX() {
      return parseFloat(this.playerX['batting_average']) >= parseFloat(this.playerY['batting_average'])
    },
    battingAverageY() {
      return parseFloat(this.playerX['batting_average']) <= parseFloat(this.playerY['batting_average'])
    },
    homeRunX() {
      return parseInt(this.playerX['home_run']) >= parseInt(this.playerY['home_run'])
    },
    homeRunY() {
      return parseInt(this.playerX['home_run']) <= parseInt(this.playerY['home_run'])
    },
    runsBattedInX() {
      return parseInt(this.playerX['runs_batted_in']) >= parseInt(this.playerY['runs_batted_in'])
    },
    runsBattedInY() {
      return parseInt(this.playerX['runs_batted_in']) <= parseInt(this.playerY['runs_batted_in'])
    },
    stolenBaseX() {
      return parseInt(this.playerX['stolen_base']) >= parseInt(this.playerY['stolen_base'])
    },
    stolenBaseY() {
      return parseInt(this.playerX['stolen_base']) <= parseInt(this.playerY['stolen_base'])
    },
    onBasePercentageX() {
      return parseFloat(this.playerX['on_base_percentage']) >= parseFloat(this.playerY['on_base_percentage'])
    },
    onBasePercentageY() {
      return parseFloat(this.playerX['on_base_percentage']) <= parseFloat(this.playerY['on_base_percentage'])
    },
    onBasePlusSluggingX() {
      return parseFloat(this.playerX['on_base_plus_slugging']) >= parseFloat(this.playerY['on_base_plus_slugging'])
    },
    onBasePlusSluggingY() {
      return parseFloat(this.playerX['on_base_plus_slugging']) <= parseFloat(this.playerY['on_base_plus_slugging'])
    },
    walksX() {
      return parseInt(this.playerX['walks']) >= parseInt(this.playerY['walks'])
    },
    walksY() {
      return parseInt(this.playerX['walks']) <= parseInt(this.playerY['walks'])
    },
    hitByPitchX() {
      return parseInt(this.playerX['hit_by_pitch']) >= parseInt(this.playerY['hit_by_pitch'])
    },
    hitByPitchY() {
      return parseInt(this.playerX['hit_by_pitch']) <= parseInt(this.playerY['hit_by_pitch'])
    },
    scoringPositionBattingAverageX() {
      return parseFloat(this.playerX['scoring_position_batting_average']) >= parseFloat(this.playerY['scoring_position_batting_average'])
    },
    scoringPositionBattingAverageY() {
      return parseFloat(this.playerX['scoring_position_batting_average']) <= parseFloat(this.playerY['scoring_position_batting_average'])
    },
    strikeoutX() {
      return parseInt(this.playerX['strikeout']) <= parseInt(this.playerY['strikeout'])
    },
    strikeoutY() {
      return parseInt(this.playerX['strikeout']) >= parseInt(this.playerY['strikeout'])
    },
    errorX() {
      return parseInt(this.playerX['error']) <= parseInt(this.playerY['error'])
    },
    errorY() {
      return parseInt(this.playerX['error']) >= parseInt(this.playerY['error'])
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
