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
        <td :class="{ emphasis: isEmphasisInt(playerX['at_bat'], playerY['at_bat']) }">{{playerX['at_bat']}}</td>
        <th>打数</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['at_bat'], playerX['at_bat']) }">{{playerY['at_bat']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['hits'], playerY['hits']) }">{{playerX['hits']}}</td>
        <th>安打</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['hits'], playerX['hits']) }">{{playerY['hits']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['batting_average'], playerY['batting_average']) }">
          {{playerX['batting_average']}}
        </td>
        <th>打率</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['batting_average'], playerX['batting_average']) }">
          {{playerY['batting_average']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['home_run'], playerY['home_run']) }">{{playerX['home_run']}}</td>
        <th>HR</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['home_run'], playerX['home_run']) }">{{playerY['home_run']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['runs_batted_in'], playerY['runs_batted_in']) }">
          {{playerX['runs_batted_in']}}
        </td>
        <th>打点</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['runs_batted_in'], playerX['runs_batted_in']) }">
          {{playerY['runs_batted_in']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['stolen_base'], playerY['stolen_base']) }">{{playerX['stolen_base']}}</td>
        <th>盗塁</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['stolen_base'], playerX['stolen_base']) }">{{playerY['stolen_base']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['on_base_percentage'], playerY['on_base_percentage']) }">
          {{playerX['on_base_percentage']}}
        </td>
        <th>出塁率</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['on_base_percentage'], playerX['on_base_percentage']) }">
          {{playerY['on_base_percentage']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['on_base_plus_slugging'], playerY['on_base_plus_slugging']) }">
          {{playerX['on_base_plus_slugging']}}
        </td>
        <th>OPS</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['on_base_plus_slugging'], playerX['on_base_plus_slugging']) }">
          {{playerY['on_base_plus_slugging']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['walks'], playerY['walks']) }">{{playerX['walks']}}</td>
        <th>四球</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['walks'], playerX['walks']) }">{{playerY['walks']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerX['hit_by_pitch'], playerY['hit_by_pitch']) }">{{playerX['hit_by_pitch']}}</td>
        <th>死球</th>
        <td :class="{ emphasis: isEmphasisInt(playerY['hit_by_pitch'], playerX['hit_by_pitch']) }">{{playerY['hit_by_pitch']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisFloat(playerX['scoring_position_batting_average'], playerY['scoring_position_batting_average']) }">
          {{playerX['scoring_position_batting_average']}}
        </td>
        <th>得点圏</th>
        <td :class="{ emphasis: isEmphasisFloat(playerY['scoring_position_batting_average'], playerX['scoring_position_batting_average']) }">
          {{playerY['scoring_position_batting_average']}}
        </td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerY['strikeout'], playerX['strikeout']) }">{{playerX['strikeout']}}</td>
        <th>三振</th>
        <td :class="{ emphasis: isEmphasisInt(playerX['strikeout'], playerY['strikeout']) }">{{playerY['strikeout']}}</td>
      </tr>
      <tr>
        <td :class="{ emphasis: isEmphasisInt(playerY['error'], playerX['error']) }">{{playerX['error']}}</td>
        <th>失策</th>
        <td :class="{ emphasis: isEmphasisInt(playerX['error'], playerY['error']) }">{{playerY['error']}}</td>
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
