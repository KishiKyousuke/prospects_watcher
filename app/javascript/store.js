import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    updateFlag: true
  },
  mutations: {
    changeFlag (state) {
      state.updateFlag = !state.updateFlag
    }
  }
})
