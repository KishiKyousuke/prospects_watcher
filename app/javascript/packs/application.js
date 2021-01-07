require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import Vue from 'vue'
import ElementUI from 'element-ui'
import Vuetify from 'vuetify'

Vue.use(ElementUI)
Vue.use(Vuetify)

import '../css/application.css'
import 'element-ui/lib/theme-chalk/index.css'
import 'vuetify/dist/vuetify.min.css'
import '@mdi/font/css/materialdesignicons.css'

import '../all_teams'
import '../player_search'
import '../registered_players'
