<template>
  <div id="app">
    <vue-good-table
      @on-selected-rows-change="selectionChanged"
      :columns="columns"
      :rows="batters"
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
    batters: {
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
</style>
