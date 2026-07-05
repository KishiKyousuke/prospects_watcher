import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import Vue from 'vue'
import Vuetify from 'vuetify'
import * as VuetifyComponents from 'vuetify/lib/components'
import * as VuetifyDirectives from 'vuetify/lib/directives'
import NotifyPlugin from '../notify_plugin'

import '../channels'
import '../css/application.css'
import '@mdi/font/css/materialdesignicons.css'

import '../all_teams'
import '../player_search'
import '../registered_players'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

Vue.use(Vuetify, { components: VuetifyComponents, directives: VuetifyDirectives })
Vue.use(NotifyPlugin, { vuetify: new Vuetify() })
