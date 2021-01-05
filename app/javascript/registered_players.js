import Vue from 'vue'
import RegisteredPlayers from './RegisteredPlayers.vue'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'
import VueGoodTablePlugin from 'vue-good-table'
import 'vue-good-table/dist/vue-good-table.css'

Vue.use(ElementUI)
Vue.use(VueGoodTablePlugin)

document.addEventListener('turbolinks:load', () => {
  const registeredPlayers = document.getElementById('js-registered-players')
  if (registeredPlayers) {
    new Vue({
      render: h => h(RegisteredPlayers)
    }).$mount('#js-registered-players')
  }
})
