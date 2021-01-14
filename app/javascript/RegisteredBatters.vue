<template>
  <div id="app">
    <vue-good-table
      v-if="batters && batters.length"
      @on-selected-rows-change="selectionChanged"
      :columns="columns"
      :rows="batters"
      styleClass="vgt-table striped"
      :sort-options="{
        enabled: true,
        initialSortBy: [
            {field: 'sort_flag', type: 'desc'},
            {field: 'at_bat', type: 'desc'}
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
            <compare-batter-score-table v-if="checkedPlayers.length === 2" :checked-players="checkedPlayers" @close-modal="dialog = false"></compare-batter-score-table>
          </v-card>
        </v-dialog>
        <el-button type="danger" round size="small" @click="releaseProcessing">解除する</el-button>
      </div>
    </vue-good-table>
  </div>
</template>

<script>
import {axiosClient} from './axios_client'
import compareBatterScoreTable from './CompareBatterScoreTable'

export default {
  components: {
    compareBatterScoreTable
  },
  props: {
    batters: {
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
          label: '打数',
          field: 'at_bat',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '安打',
          field: 'hits',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '打率',
          field: 'batting_average',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: 'HR',
          field: 'home_run',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '打点',
          field: 'runs_batted_in',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '盗塁',
          field: 'stolen_base',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '出塁率',
          field: 'on_base_percentage',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: 'OPS',
          field: 'on_base_plus_slugging',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '四球',
          field: 'walks',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '死球',
          field: 'hit_by_pitch',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '得点圏',
          field: 'scoring_position_batting_average',
          type: 'number',
          firstSortType: 'desc'
        },
        {
          label: '三振',
          field: 'strikeout',
          type: 'number'
        },
        {
          label: '失策',
          field: 'error',
          type: 'number'
        },
        {
          field: 'sort_flag',
          type: 'number',
          hidden: 'true'
        }
      ]
    }
  },
  methods: {
    selectionChanged(params) {
      this.checkedPlayers = params.selectedRows
    },
    releaseProcessing() {
      this.releasePlayers()
      this.releaseNotice()
    },
    releasePlayers() {
      for (const player of this.checkedPlayers) {
        axiosClient.delete(`/api/v1/favorite_batters`, {data: {player_id: player['batter_id']}})
        const index = this.batters.findIndex(batter => batter['batter_id'] === player['batter_id'])
        this.batters.splice(index, 1)
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
