<template>
  <v-app id="app">
    <vue-good-table
      v-if="pitchers && pitchers.length"
      @on-selected-rows-change="selectionChanged"
      :columns="columns"
      :rows="pitchers"
      styleClass="vgt-table striped"
      :sort-options="{
        enabled: true,
        initialSortBy: [
            {field: 'sort_flag', type: 'desc'},
            {field: 'innings_pitched', type: 'desc'}
        ]
      }"
      :select-options="{
        enabled: true,
        selectionText: '選手を選択中',
        clearSelectionText: 'キャンセル',
        selectOnCheckboxOnly: true
      }"
    >
      <template slot="table-row" slot-scope="props">
        <span v-if="props.column.field === 'name'">
          <a :href="playerUrl(props.row.url)" target="_blank" rel="noopener noreferrer" class="player-name">{{props.row.name}}</a>
        </span>
        <span v-else-if="props.column.field === 'team'">
          <span :class="props.row.english_team_name">{{props.row.team}}</span>
        </span>
        <span v-else>
          {{props.formattedRow[props.column.field]}}
        </span>
      </template>
      <div slot="selected-row-actions">
        <v-dialog
            v-model="dialog"
            width="600px"
        >
          <template v-slot:activator="{ on, attrs }">
            <el-button v-bind="attrs" v-on="on" type="primary" size="small" round :disabled="checkedPlayers.length !== 2">比較する</el-button>
          </template>
          <v-card>
            <compare-pitcher-score-table :checked-players="checkedPlayers"></compare-pitcher-score-table>
          </v-card>
        </v-dialog>
        <el-button type="danger" size="small" round @click="releaseProcessing">解除する</el-button>
      </div>
    </vue-good-table>
  </v-app>
</template>

<script>
import {axiosClient} from './axios_client'
import comparePitcherScoreTable from './ComparePitcherScoreTable'

export default {
  components: {
    comparePitcherScoreTable
  },
  props: {
    pitchers: {
      type: Array,
      require: true
    }
  },
  data: function () {
    return {
      checkedPlayers: [],
      dialog: false,
      columns: [
        {
          label: '背番号',
          field: 'number',
          type: 'number',
          sortable: false
        },
        {
          label: '選手名',
          field: 'name',
          sortable: false
        },
        {
          label: 'チーム',
          field: 'team',
          sortable: false
        },
        {
          label: '防御率',
          field: 'earned_run_average',
          type: 'number'
        },
        {
          label: '勝',
          field: 'win',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '負',
          field: 'lose',
          type: 'number'
        },
        {
          label: '投球回',
          field: 'innings_pitched',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '登板',
          field: 'pitched',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: 'セーブ',
          field: 'number_of_save',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: 'HP',
          field: 'hold_point',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '三振',
          field: 'strikeout',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '奪三振率',
          field: 'strikeouts_per_nine_innings',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: 'K/BB',
          field: 'strikeout_to_walk_ratio',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: 'WHIP',
          field: 'walks_and_hits_per_innings_pitched',
          type: 'number'
        },
        {
          field: 'sort_flag',
          type: 'number',
          hidden: true
        }
      ]
    }
  },
  methods: {
    selectionChanged(params) {
      this.checkedPlayers = params.selectedRows
    },
    releaseProcessing() {
      this.releasePitchers()
      this.releaseNotice()
    },
    releasePitchers() {
      for (const player of this.checkedPlayers) {
        axiosClient.delete(`/api/v1/favorite_pitchers`, {data: {player_id: player['pitcher_id']}})
        const index = this.pitchers.findIndex(pitcher => pitcher['pitcher_id'] === player['pitcher_id'])
        this.pitchers.splice(index, 1)
      }
    },
    releaseNotice() {
      this.$notify({
        title: '登録解除',
        message: '選手を登録から解除しました',
        type: 'warning'
      })
    },
    playerUrl(url) {
      return 'https://baseball.yahoo.co.jp' + url
    }
  }
}
</script>

<style scoped>
/deep/ .vgt-selection-info-row {
  line-height: 32px;
}

/deep/ [type="checkbox"]:not(:checked) {
  position: initial;
  opacity: 0.5;
  pointer-events: auto;
}

/deep/ [type="checkbox"]:checked {
  position: initial;
  opacity: 1.0;
  pointer-events: auto;
}

.el-button {
  color: white;
  font-weight: bold;
}

.player-name {
  font-weight: bold;
}

.hawks:before {
  content: '';
  border-left: thick solid #FEA409;
  padding-left: 8px;
}

.marines:before {
  content: '';
  border-left: thick solid #6E6E6E;
  padding-left: 8px;
}

.lions:before {
  content: '';
  border-left: thick solid #192546;
  padding-left: 8px;
}

.eagles:before {
  content: '';
  border-left: thick solid #7F001E;
  padding-left: 8px;
}

.fighters:before {
  content: '';
  border-left: thick solid #285A8A;
  padding-left: 8px;
}

.buffaloes:before {
  content: '';
  border-left: thick solid #34328A;
  padding-left: 8px;
}

.giants:before {
  content: '';
  border-left: thick solid #E96D06;
  padding-left: 8px;
}

.tigers:before {
  content: '';
  border-left: thick solid #FED80C;
  padding-left: 8px;
}

.dragons:before {
  content: '';
  border-left: thick solid #113C7C;
  padding-left: 8px;
}

.baystars:before {
  content: '';
  border-left: thick solid #1182D8;
  padding-left: 8px;
}

.carp:before {
  content: '';
  border-left: thick solid #C70019;
  padding-left: 8px;
}

.swallows:before {
  content: '';
  border-left: thick solid #1A753E;
  padding-left: 8px;
}
</style>
