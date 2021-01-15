import Vue from 'vue'
import RegisteredPlayers from './RegisteredPlayers.vue'
import VueGoodTablePlugin from 'vue-good-table'
import 'vue-good-table/dist/vue-good-table.css'
import Vuetify from 'vuetify'

Vue.use(VueGoodTablePlugin)

document.addEventListener('DOMContentLoaded', () => {
  const registeredPlayers = document.getElementById('js-registered-players')
  if (registeredPlayers) {
    new Vue({
      render: h => h(RegisteredPlayers),
      vuetify: new Vuetify()
    }).$mount('#js-registered-players')
  }
})
