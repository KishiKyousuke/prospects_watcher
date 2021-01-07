import Vue from 'vue'
import PlayerSearch from './PlayerSearch.vue'
import 'vue-simple-suggest/dist/styles.css'

document.addEventListener('turbolinks:load', () => {
  const playerSearch = document.getElementById('js-player-search')
  if (playerSearch) {
    new Vue({
      render: h => h(PlayerSearch)
    }).$mount('#js-player-search')
  }
})
