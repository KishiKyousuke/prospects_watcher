import Vue from 'vue'
import RegisteredPlayers from './RegisteredPlayers.vue'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(ElementUI)

document.addEventListener('turbolinks:load', () => {
  const registeredPlayers = document.getElementById('js-registered-players')
  if (registeredPlayers) {
    new Vue({
      render: h => h(RegisteredPlayers)
    }).$mount('#js-registered-players')
  }
})
