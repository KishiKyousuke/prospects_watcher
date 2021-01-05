<template>
  <div id="app">
    <vue-good-table
      @on-selected-rows-change="selectionChanged"
      :columns="columns"
      :rows="pitchers"
      :select-options="{
        enabled: true,
        selectionText: '選手を選択中',
        clearSelectionText: 'キャンセル',
        selectOnCheckboxOnly: true
      }"
    >
      <template slot="table-row" slot-scope="props">
        <span v-if="props.column.field === 'name'">
          <a :href="playerUrl(props.row.url)" target="_blank" rel="noopener noreferrer">{{props.row.name}}</a>
        </span>
        <span v-else>
          {{props.formattedRow[props.column.field]}}
        </span>
      </template>
      <div slot="selected-row-actions">
        <el-button type="danger" size="small" round @click="releaseProcessing">解除する</el-button>
      </div>
    </vue-good-table>
  </div>
</template>

<script>
import {axiosClient} from './axios_client'

export default {
  props: {
    pitchers: {
      type: Array,
      require: true
    }
  },
  data: function () {
    return {
      checkedPlayers: [],
      columns: [
        {
          label: '背番号',
          field: 'number',
          type: 'number'
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
</style>
