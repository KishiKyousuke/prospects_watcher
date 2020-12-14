import Vue from 'vue'
import AllTeams from './all_teams.vue'
import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css'

Vue.use(ElementUI)

document.addEventListener('turbolinks:load', () => {
  const allTeams = document.getElementById('js-all-teams')
  if (allTeams) {
    new Vue({
      render: h => h(AllTeams)
    }).$mount('#js-all-teams')
  }
})
