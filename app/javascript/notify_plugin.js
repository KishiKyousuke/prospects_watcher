// Element UI の Notification (`this.$notify({ title, message, type })`) の代替。
// element-ui 撤去に伴い、同じ呼び出しシグネチャを維持したまま Vuetify の v-snackbar で
// 通知を表示する。呼び出し側 (RegisterButton.vue, RegisteredBatters.vue,
// RegisteredPitchers.vue, PlayerSearch.vue) の変更は不要。
//
// アプリには all_teams.js / player_search.js / registered_players.js のように
// 独立した Vue ルートインスタンスが複数存在するため、通知用の表示領域は
// document.body 直下にマウントする単一のホスト Vue インスタンスとして持ち、
// どのルートから `this.$notify(...)` が呼ばれても同じスナックバーを共有する。

const COLORS = {
  success: 'success',
  error: 'error',
  warning: 'warning'
}

export default {
  install(Vue, { vuetify } = {}) {
    if (Vue.prototype.$notify) return

    const state = Vue.observable({
      show: false,
      title: '',
      message: '',
      color: 'success'
    })

    const container = document.createElement('div')
    document.body.appendChild(container)

    new Vue({
      vuetify,
      data: state,
      render(h) {
        return h('v-snackbar', {
          props: {
            value: this.show,
            color: this.color,
            timeout: 4000, // Element UI Notification のデフォルトに近い表示時間として設定
            top: true,
            right: true
          },
          on: {
            input: (value) => { this.show = value }
          }
        }, [
          h('strong', [this.title]),
          h('div', [this.message])
        ])
      }
    }).$mount(container)

    Vue.prototype.$notify = function ({ title, message, type }) {
      state.title = title
      state.message = message
      if (!COLORS[type]) {
        console.warn(`$notify: unknown type "${type}", falling back to "success"`)
      }
      state.color = COLORS[type] || COLORS.success
      state.show = true
    }
  }
}
