import Vue from 'vue'
import AllTeams from './AllTeams.vue'
import Vuetify from 'vuetify'

document.addEventListener('turbolinks:load', () => {
  const allTeams = document.getElementById('js-all-teams')
  if (allTeams) {
    new Vue({
      render: h => h(AllTeams),
      vuetify: new Vuetify()
    }).$mount('#js-all-teams')
  }
})
