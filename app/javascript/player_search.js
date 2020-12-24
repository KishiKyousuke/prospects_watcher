import Vue from 'vue'
import PlayerSearch from './PlayerSearch.vue'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import 'vue-simple-suggest/dist/styles.css'

Vue.use(ElementUI)

document.addEventListener('turbolinks:load', () => {
  const playerSearch = document.getElementById('js-player-search')
  if (playerSearch) {
    new Vue({
      render: h => h(PlayerSearch)
    }).$mount('#js-player-search')
  }
})
